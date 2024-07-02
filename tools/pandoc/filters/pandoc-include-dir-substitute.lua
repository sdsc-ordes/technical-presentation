-- Replace env/meta variables in image urls.

local logging = require("modules.logging")
local strings = require("modules.strings")

PANDOC_VERSION:must_be_at_least("2.12")

local metaMap
-- Save meta table for var_replace.
function get_vars(meta)
  metaMap = meta
end

return {
  { Meta = get_vars },
  {
    Image = function(image)
      image.src = strings.var_replace(image.src, metaMap, env, true)
      logging.info("Replace vars in image '" .. image.src .. "'")
      return image
    end,
  },
}
