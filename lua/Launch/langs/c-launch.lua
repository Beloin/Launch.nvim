--- c-launch.lua
local M = {}

local dft_launch = require('Launch.langs.default-launch')

---@param config DapConfig
---@param lang_name string
function M.insert_dap_config(config, lang_name)
  return dft_launch.insert_dap_config(config, lang_name)
end

return M
