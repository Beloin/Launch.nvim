--- default.launch.lua
local M = {}

local dap = require("dap")
local utils = require("Launch.utils")

---@param config DapConfig
---@param lang_name string
function M.insert_dap_config(config, lang_name)
	if not lang_name then
		utils.notify_error("Language not informed")
		return
	end
	lang_name = string.lower(lang_name)

	local configs = dap.configurations[lang_name]
	if configs then
		for i, cfg in pairs(configs) do
			if cfg.name == config.name then
				configs[i] = config
				return
			end
		end
		table.insert(configs, config)
		return
	end

	dap.configurations[lang_name] = { config }
end

return M
