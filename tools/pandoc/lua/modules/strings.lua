local M = {}
local logging = require("modules.logging")
local utils = require("pandoc.utils")

--- Replace `text` with values from environment
--- and meta data (stringifing).
function M.var_replace(text, metaMap, env, url_escape_delim)
  local delim_l = url_escape_delim == true and "%%7B" or "{"
  local delim_r = url_escape_delim == true and "%%7D" or "}"

  local function replace(what, var)
    local repl = nil
    if what == "env" then
      repl = env[var]
    elseif what == "meta" then
      local v = metaMap[var]
      if v then
        repl = utils.stringify(v)
      end
    end

    if repl == nil then
      logging.info("Could not replace variable in string: '" .. var .. "'\n")
    end

    return repl
  end

  return text:gsub("%$" .. delim_l .. "(%l+):([^}]+)" .. delim_r, replace)
end

return M
