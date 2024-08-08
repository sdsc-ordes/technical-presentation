PANDOC_VERSION:must_be_at_least("3.1")

local logging = require("modules.logging")
local strings = require("modules.strings")
local utils = require("modules.utils")

-- local abs_pwd = require("pandoc.system").get_working_directory()
local path = require("pandoc.path")
local stringify = require("pandoc.utils").stringify

local function open_in_new_window(link)
  if link.target:match("^http") then
    link.attributes["target"] = "_blank"
    return link
  end

  return nil
end

return { { Link = open_in_new_window } }
