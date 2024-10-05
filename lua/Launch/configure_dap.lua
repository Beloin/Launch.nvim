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
	lang = string.lower(lang)

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
	parser.load()

	if not parser.is_loaded() then
		notify_error("Not loaded any configuration")
		return
	end

	set_env()

	local type = parser.get_type()
	local lang = parser.get_lang()

	local name = parser.get_name()
	local request = parser.get_request()

	local program = parser.get_program()

	local args = parser.get_args()

	-- TODO: Use the default config, or extend from another already there?
	-- extends: "Launch File"
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
	notify_status("Loaded configuration")
end

function M.debug()
	local ut = require("Launch.utils")
	local tb = dap.configurations["c"]
	if tb then
		print("Type: ", tb["type"])
		print("Request", tb["request"])
		print("Name", tb["name"])
		ut.dump(tb)
		return
	end

  print('Adapters:')
	local tb2 = dap.adapters["c"]
	if tb2 then
		print("Type: ", tb2["type"])
		print("Request", tb2["request"])
		print("Name", tb2["name"])
		ut.dump(tb2)
		return
	end


  print('-----------------------')
  print('All Adapters:')
  ut.dump(dap.adapters)
  print('All Configurations:')
  ut.dump(dap.configurations)
end

return M
