--- include-files.lua – filter to include Markdown files
---
--- Copyright: © 2019–2021 Albert Krewinkel
--- License:   MIT – see LICENSE file for details

-- Module pandoc.path is required and was added in version 2.12

PANDOC_VERSION:must_be_at_least("3.1")

local logging = require("modules.logging")
local strings = require("modules.strings")
local utils = require("modules.utils")

local List = require("pandoc.List")
local path = require("pandoc.path")
local system = require("pandoc.system")
local cs = PANDOC_STATE

-- Save env. variables and root working dir.
local env = system.environment()
local cwd = system.get_working_directory()

--- Replace extension by attribute `replace-ext-if-format='formatA:<extB>;formatB:<extA>;...'
local function replace_ext(cb, file)
  if cb.attributes["replace-ext-if-format"] then
    local new_ext = cb.attributes["replace-ext-if-format"]:match(FORMAT .. ":([^;]*)")
    if new_ext then
      file, count = file:gsub("^(.+)%..+$", "%1" .. new_ext, 1)
      if not count then
        -- If no extension replaced, add to the back
        file = file + new_ext
      end
    end
  end
  return file
end

--- Replace variables in code blocks
local metaMap

--- Include/exclude by attribute
--- `exclude-if-format='formatA;formatB;...'
--- `include-if-format='formatA;formatB;...`
--- Default: true
local function is_included(cb)
  local include = true
  local exclude = false

  if cb.attributes["include-if-format"] then
    include = cb.attributes["include-if-format"]:match(FORMAT) ~= nil
  end

  if cb.attributes["exclude-if-format"] then
    exclude = cb.attributes["exclude-if-format"]:match(FORMAT) ~= nil
  end

  return include == true and exclude == false
end

--- Get default settings
local META_KEY = "include-files"
local meta = nil
local auto_header_shift = false
local default_format = nil
local fail_if_read_error = false
local relative_to_cwd = false

function get_meta(mt)
  local default_meta = utils.load_default_meta(META_KEY)
  logging.info(default_meta)

  meta = utils.get_meta(mt, default_meta, META_KEY)

  auto_header_shift = meta["auto-header-shift"]
  default_format = meta["default-format"]
  fail_if_read_error = meta["fail-if-read-error"]
  relative_to_cwd = meta["paths-relative-to-cwd"]

  -- Save meta table for var_replace.
  metaMap = mt
end

--- Keep last heading level found.
local last_heading_level = 0
function update_last_level(header)
  last_heading_level = header.level
end

--- Update contents of included file
local function update_contents(blocks, shift_by, include_path)
  local update_contents_filter = {
    -- Shift headings in block list by given number.
    Header = function(header)
      if shift_by then
        header.level = header.level + shift_by
      end
      return header
    end,
    -- If image paths are relative then prepend include file path.
    Image = function(image)
      if (not relative_to_cwd or image.classes:includes("relative-to-current")) and path.is_relative(image.src) then
        image.src = path.normalize(path.join({ include_path, image.src }))
        logging.info("Updated image path: ", image.src)
      end
      return image
    end,
    -- Update path for include-code-files.lua filter style CodeBlocks
    CodeBlock = function(cb)
      if
          (not relative_to_cwd or cb.classes:includes("relative-to-current"))
          and cb.attributes.include
          and path.is_relative(cb.attributes.include)
      then
        cb.attributes.include = path.normalize(path.join({ include_path, cb.attributes.include }))
      end
      return cb
    end,
  }

  return pandoc.walk_block(pandoc.Div(blocks), update_contents_filter).content
end

--- Filter function for code blocks.
local transclude
function transclude(cb)
  -- ignore code blocks which are not of class "include".
  if not cb.classes:includes("include") then
    return
  end

  -- Filter by includes and excludes.
  if not is_included(cb) then
    return List({}) -- remove block
  end

  -- Variable substitution.
  cb.text = strings.var_replace(cb.text, metaMap, env)

  local format = cb.attributes["format"]
  if not format then
    -- Markdown is used if this is nil.
    format = default_format
  end

  -- Check if we include the file as raw inline.
  local raw = cb.attributes["raw"]
  raw = raw == "true"

  -- Attributes shift headings
  local shift_heading_level_by = 0
  local shift_input = cb.attributes["shift-heading-level-by"]
  if shift_input then
    shift_heading_level_by = math.tointeger(shift_input)
  else
    if auto_header_shift then
      -- Auto shift headings.
      shift_heading_level_by = last_heading_level
    end
  end

  --- Keep track of level before recursion.
  local buffer_last_heading_level = last_heading_level

  local blocks = List:new()
  for line in cb.text:gmatch("[^\n]+") do
    if line:sub(1, 2) == "//" then
      goto skip_to_next
    end

    -- Replace extension if specified
    line = replace_ext(cb, line)

    if cs.verbosity == "INFO" then
      logging.info(string.format("Including: [format: %s, raw: %s]\n - '%s'\n", format, tostring(raw), line))
    end

    -- Make relative include path relative to pandoc's working
    -- dir and make it absolute.
    --
    if path.is_relative(line) then
      if relative_to_cwd and not cb.classes:includes("relative-to-current") then
        line = path.normalize(path.join({ cwd, line }))
      end
    end

    local fh = io.open(line)
    if not fh then
      local msg = "Cannot find include file: '" .. line .. "', curr. working dir: '" .. cwd .. "'"
      if fail_if_read_error then
        logging.error(msg .. " | error\n")
        error("Abort due to include failure")
      else
        logging.warning(msg .. " | skipping include\n")
        goto skip_to_next
      end
    end

    -- Read the file.
    local text = fh:read("*a")
    fh:close()

    if raw then
      -- Include as raw inline element.
      blocks:extend({ pandoc.RawBlock(format, text) })
    else
      -- Include as parsed AST
      local contents = pandoc.read(text, format, PANDOC_READER_OPTIONS).blocks
      last_heading_level = 0

      -- Recursive transclusion.
      contents = system.with_working_directory(path.directory(line), function()
        return pandoc.walk_block(pandoc.Div(contents), { Header = update_last_level, CodeBlock = transclude })
      end).content

      --- Reset to level before recursion.
      last_heading_level = buffer_last_heading_level
      blocks:extend(update_contents(contents, shift_heading_level_by, path.directory(line)))
    end

    ::skip_to_next::
  end

  return blocks
end

return {
  { Meta = get_meta },
  { Header = update_last_level, CodeBlock = transclude },
}
