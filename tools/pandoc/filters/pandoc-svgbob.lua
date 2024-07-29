PANDOC_VERSION:must_be_at_least("3.1")

local logging = require("modules.logging")
local strings = require("modules.strings")
local utils = require("modules.utils")

-- local abs_pwd = require("pandoc.system").get_working_directory()
local path = require("pandoc.path")
local stringify = require("pandoc.utils").stringify

local META_KEY = "svgbob"
local meta = {}

local MESSAGE = "Convert svgbob to '%s'."
local BYPASS = "Skipping conversion as target '%s' exists."
local NOT_FOUND = "'%s': file not found"

local function get_meta(mt)
  local default_meta = utils.load_default_meta(META_KEY)
  assert(default_meta)

  meta = utils.get_meta(mt, default_meta, META_KEY)
end

local function render_svgbob(img)
  if not img.classes:includes(META_KEY) then
    return
  end

  logging.info("Converting codeblock with svgbob")

  -- Remove svgbob class
  local source_file = img.src
  local dest_dir = os.getenv("IMAGE_CONVERT_ROOT")
  if not dest_dir then
    logging.error("Env. variable IMAGE_CONVERT_ROOT not set.")
    os.exit(1)
  end

  if not utils.file_exists(source_file) then
    logging.error(string.format(NOT_FOUND, source_file))
    os.exit(1)
  end

  local content = io.open(source_file, "rb"):read("a")
  local hash = pandoc.utils.sha1(content .. stringify(meta))
  dest_file = path.join({ dest_dir, hash .. ".svg" })

  img.classes = img.classes:filter(function(it)
    return not it ~= "svgbob"
  end)
  img.src = dest_file

  if utils.file_exists(dest_file) then
    logging.info(string.format(BYPASS, dest_file))
    return img
  end

  local font_family = '"' .. stringify(meta["font-family"]) .. '"'
  local font_size = stringify(meta["font-size"])
  local scale = stringify(meta["scale"])
  local stroke_width = stringify(meta["stroke-width"])
  local stroke_color = stringify(meta["stroke-color"])
  local fill_color = stringify(meta["fill-color"])
  local background = stringify(meta["background"])

  pandoc.pipe("svgbob", {
    source_file,
    "--font-family",
    font_family,
    "--font-size",
    font_size,
    "--scale",
    scale,
    "--stroke-width",
    stroke_width,
    "--stroke-color",
    stroke_color,
    "--fill-color",
    fill_color,
    "--background",
    background,
    "-o",
    dest_file,
  }, "")

  logging.info(string.format(MESSAGE, hash))

  return img
end

return { { Meta = get_meta }, { Image = render_svgbob } }
