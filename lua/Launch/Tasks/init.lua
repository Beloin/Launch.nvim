local M = {}

local launch_parser = require("Launch.parser")
local tasks_parser = require("Launch.Tasks.parser")
local picker = require("Launch.Tasks.picker")
local utils = require("Launch.utils")

M.__tasks = {}

function M.configure()
	M.__tasks = {}
	launch_parser.load()
	utils.notify_status("Loaded Configurations")

	local task_table = launch_parser.get_tasks()
	if not task_table then
		utils.notify_error("Problems loading task table: " .. task_table)
		return false
	end

	local has_tasks = tasks_parser.load_tasks(task_table)
	if not has_tasks then
		utils.notify_error("Problems loading tasks: has no task")
		return false
	end

	local ok, tasks = tasks_parser.get_tasks()

	M.__tasks = tasks or {}
	return ok
end

local function insert_preview()
	if not M.__tasks then
		return nil
	end

	for _, task in ipairs(M.__tasks) do
		task["preview"] = vim.inspect(task)
	end

	return M.__tasks
end

function M.launch_tasks()
  -- TODO: Add loader here
	insert_preview()
	local o = M.__tasks or {}
	picker.run_picker(o, function(itemExample)
		local shouldProceed = itemExample and itemExample.pipeline and #itemExample.pipeline > 0

		if shouldProceed then
			for _, cmd in ipairs(itemExample.pipeline) do
				local ok, output = utils.run_sh(cmd)

				if ok then
					if output and #output > 0 then
						utils.notify_status(output)
					end
				else
					utils.notify_error("Could not run `" .. cmd .. "` ")
				end
			end

			utils.notify_status("Tasks done 🚀")
		end
	end)
end

return M
