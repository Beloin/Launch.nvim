--- dap.launch.lua
local M = {}

local utils = require("Launch.utils")

--- Get module to load for specif language
---@param files string[]
---@param lang string
local function search_file(files, lang)
	local result = "default"
	for _, value in ipairs(files) do
		local found = string.find(value, lang)
		if found then
			result = lang
			break
		end
	end

	return "Launch.langs." .. result .. "-launch"
end

--- Loads config
---@param lang string
---@return table
local function load_config(lang)
	local dirname = string.sub(debug.getinfo(1).source, 2, string.len("/dap-launch.lua") * -1)
	local files = utils.scandir(dirname .. "/langs")
	local toLoad = search_file(files, lang)
	-- Example: require("Launch.langs.default-launch")
	local module = require(toLoad)
	return module
end

---@param config DapConfig
---@param lang_name string
function M.insert_config(config, lang_name)
	local module = load_config(lang_name)
	module.insert_dap_config(config, lang_name)
end

return M
