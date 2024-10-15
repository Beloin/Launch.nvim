--- javalaunch.lua
local M = {}

local dap = require("dap")
local utils = require("Launch.utils")

local function extract_confs(config, configs)
	local launchConfig = nil
	local launchNamed = nil
	local launchNamedIndex = nil
	if configs then
		for i, cfg in pairs(configs) do
			if cfg.request == "launch" then
				launchConfig = cfg
			end
			if cfg.name == config.name then
				launchNamed = cfg
				launchNamedIndex = i
				break
			end
		end
	end
	return launchConfig, launchNamed, launchNamedIndex
end

--- Configure internal config
---@param config DapConfig
---@param newConfig table
local function configure_specific_calls(config, newConfig)
	newConfig["program"] = nil

	local args = config.args
	if type(args) == "function" then
		local argList = args()
		newConfig["args"] = table.concat(argList, " ")
	elseif type(args) == "table" then
		newConfig["args"] = table.concat(args, " ")
	else
		newConfig["args"] = args
	end

	config.setenv()
end

--- TODO: For now we don't have Args, neither Pipeline, only env

---@param config DapConfig
---@param lang_name string
function M.insert_dap_config(config, lang_name)
	lang_name = "java"

	local newConfig = utils.shallow_copy(config)

	local configs = dap.configurations[lang_name]
	local launchConfig, launchNamed, launchNamedIndex = extract_confs(config, configs)

	if launchConfig then
		utils.shallow_copy(launchConfig, newConfig, { "name" })
		configure_specific_calls(config, newConfig)
	else
		utils.notify_error(
			'Could not find any launch request.\nDo you have "nvim-jdtls" installed, or has initialized it?'
		)
		return
	end

	if launchNamed and launchNamedIndex then
		---@diagnostic disable-next-line: assign-type-mismatch
		configs[launchNamedIndex] = newConfig
		return
	end

	if configs then
		table.insert(configs, newConfig)
	else
		---@diagnostic disable-next-line: assign-type-mismatch
		dap.configurations[lang_name] = { newConfig }
	end
end

return M
