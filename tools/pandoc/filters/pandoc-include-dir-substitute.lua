-- Replace env/meta variables in image urls.

local logging = require("modules.logging")
local strings = require("modules.strings")

PANDOC_VERSION:must_be_at_least("3.1")

local metaMap
-- Save meta table for var_replace.
local function get_vars(meta)
  metaMap = meta
end

return {
  { Meta = get_vars },
  {
    Image = function(image)
      local src = strings.var_replace(image.src, metaMap, env, true)
      logging.info(string.format("Replaced vars in image '%s' to '%s'", image.src, src))

      image.src = src
      return image
    end,
  },
}
