local M = {}
local logging = require("modules.logging")
local utils = require("pandoc.utils")
local path = require("pandoc.path")

function M.load_default_meta(key)
  local pwd, _ = path.directory(PANDOC_SCRIPT_FILE)
  local file = path.join({ pwd, "metadata-default.md" })
  local metafile = io.open(file, "r")

  if metafile == nil then
    logging.error("Cannot open file:", file)
    os.exit(1)
  end

  logging.info("Reading default meta: ", file)

  local content = metafile:read("*a")
  metafile:close()
  if content == nil then
    logging.error("Cannot read file: ", metafile)
    os.exit(1)
  end

  local default_meta = pandoc.read(content, "markdown").meta
  assert(default_meta, "Could not parse file as markdown: " .. file)

  local meta = default_meta[key]
  assert(meta, "Key '" .. key .. "' not inside file:" .. file)

  return meta
end

-- Get all meta variables under a specific key `meta_key`.
-- Check against the `default_meta`.
function M.get_meta(doc_meta, default_meta, meta_key)
  local NOT_FOUND = "metadata '%s' was not found in source, applying default:"

  local meta = doc_meta[meta_key]

  if meta ~= nil then
    -- Check for all values available.
    for k, v in pairs(default_meta) do
      if meta[k] == nil then
        meta[k] = v
        logging.info(string.format(NOT_FOUND, meta_key .. "." .. k), v)
      end
    end
  else
    meta = default_meta
    logging.info(string.format(NOT_FOUND, meta_key), default_meta)
  end

  return meta
end

function M.file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

return M
