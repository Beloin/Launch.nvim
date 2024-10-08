local M = {}

local launch_parser = require("Launch.parser")
local tasks_parser = require("Launch.Tasks.parser")
local picker = require("Launch.Tasks.picker")

M.__tasks = {}

function M.configure()
	M.__tasks = {}
	launch_parser.load()

	local task_table = launch_parser.get_tasks()
	if not task_table then
		return false
	end

	local has_tasks = tasks_parser.load_tasks(task_table)
	if not has_tasks then
		return false
	end

	local ok, tasks = tasks_parser.get_tasks()

	M.__tasks = tasks or {}
	return ok
end

function M.launch_tasks()
	picker.run_picker({})
end

return M
