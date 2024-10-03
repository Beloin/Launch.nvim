local M = {}

local dap = require("dap")
local parser = require("Launch.parser")

local function set_env()
	local tb = parser.get_env()
	if not tb then
		return
	end
	for key, value in pairs(tb) do
		vim.fn.setenv(key, value)
	end
end

M.configure = function()
	print("Loading Configuration")
  parser.load()
  set_env()
end

return M
