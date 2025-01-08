local M = {}

local dap = require("dap")
local dap2 = require("dap.session")
local parser = require("Launch.parser")
local noice = require("noice")
local utils = require("Launch.utils")
local daplaunch = require("Launch.dap-launch")

local show_result = false

local function set_env(env_tb)
	if not env_tb then
		return
	end
	for key, value in pairs(env_tb) do
		vim.fn.setenv(key, value)
	end
end

local function notify_status(msg)
	noice.notify(msg, "info", { title = "Launch.nvim" })
end

local function notify_error(msg)
	noice.notify(msg, "error", { title = "Launch.nvim" })
end

---@param config DapConfig
---@param lang string
local function insert_config(config, lang)
	daplaunch.insert_config(config, lang)
end

local function run_pipeline(pipeline)
	for index = 1, #pipeline do
		local cmd = pipeline[index]
		notify_status("Running: " .. cmd)
		local ok, result = utils.run_sh(cmd)
		if ok then
			if show_result then
				notify_status(result)
			end
			notify_status("Finished: " .. cmd)
		else
			notify_error("Failed to run " .. cmd)
			return nil
		end
	end
end

local function parse_config()
	-- TODO: Launch error for necessary fields
	-- Actually use default value if those are none
	local type = parser.get_type()
	local lang = parser.get_lang()

	local name = parser.get_name()
	local request = parser.get_request()

	local program = parser.get_program()

	local args = parser.get_args()

	local should_prep = parser.should_preprocess()
	local pipeline = parser.get_pipeline()

	local env_tb = parser.get_env()

	local cwd = parser.get_cwd() or vim.fn.getcwd()

	local config = {
		name = name,

		request = request,
		type = type,

		pipeline = function()
			if should_prep then
				if pipeline then
					notify_status("Running Pipeline")
					run_pipeline(pipeline)
					notify_status("Pipeline Finished")
				end
			end
		end,

		program = function()
			if should_prep then
				-- Run pipeline
				if pipeline then
					notify_status("Running preprocess")
					run_pipeline(pipeline)
					notify_status("Pipeline Finished")
				end
			end

			if program then
				return program
			end

			notify_error('Could not load "program" in launch.nvim')
			-- TODO: Fail safe here instead of returning nil
			-- TODO: Return default if program is nil
			return nil
		end,

		args = function()
			-- Set env before running program
			set_env(env_tb)

			if args then
				return args
			end

			return nil
		end,

    setenv = function ()
			set_env(env_tb)
    end,

		cwd = cwd,
	}

	insert_config(config, lang)
end

M.configure = function()
	notify_status("Loading Configurations")
	parser.load()

	if not parser.is_loaded() then
		notify_error("Not loaded any configuration")
		return
	end

	for i = 1, parser.get_config_size(), 1 do
		parser.set_index(i)
		parse_config()
	end

	notify_status("Loaded configurations")
end

function M.debug()
	notify_status("Starting Launch.nvim debug session")
	parser.load()

	print("Amount: " .. parser.get_config_size())
	print(vim.inspect(parser.__current_table))

	parser.reset()
end

return M
