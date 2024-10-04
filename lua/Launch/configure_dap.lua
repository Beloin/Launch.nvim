local M = {}

local dap = require("dap")
local parser = require("Launch.parser")
local noice = require("noice")

local function set_env()
	local tb = parser.get_env()
	if not tb then
		return
	end
	for key, value in pairs(tb) do
		vim.fn.setenv(key, value)
	end
end

local function insert_config(config, lang)
	local tb = dap.configurations[lang]
	if tb then
		table.insert(tb, config)
		return
	end

	dap.configurations[lang] = config
end

local function notify_status(msg)
	noice.notify(msg, "info", { title = "Launch.nvim" })
end

local function notify_error(msg)
	noice.notify(msg, "error", { title = "Launch.nvim" })
end

-- TODO: Later use the array of parsed configurations
M.configure = function()
	notify_status("Loading Configurations")
	print("Loading Configuration")
	parser.load()
	set_env()

	local type = parser.get_type()
	local lang = parser.get_lang()

	local name = parser.get_name()
	local request = parser.get_request()

	local program = parser.get_program()

	local args = parser.get_args()

	local config = {
		name = name,

		request = request,
		type = type,

		program = function()
			if parser.should_preprocess() then
				local pipeline = parser.get_pipeline()

				-- Run pipeline
				if pipeline then
					notify_status("Running preprocess")
					for index = 1, #pipeline do
						print("Running " .. pipeline[index])
						notify_status("Running " .. pipeline[index])
						vim.cmd(pipeline[index])
					end
				end

				if program then
					return program
				end

				notify_error('Could not load "program" in launch.nvim')
				-- TODO: Fail safe here instead of returning nil
				return nil
			end
		end,

		args = function()
			if args then
				return args
			end

			return nil
		end,
	}

	insert_config(config, lang)
end

return M
