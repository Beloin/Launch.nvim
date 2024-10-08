local M = {}

local launch_parser = require("Launch.parser")
local tasks_parser = require("Launch.Tasks.parser")
local picker = require("Launch.Tasks.picker")
local utils = require("Launch.utils")

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

local function insert_preview()
	if not M.__tasks then
		return nil
	end

	for _, task in ipairs(M.__tasks) do
		task["preview"] = utils.dump(task)
	end

	return M.__tasks
end

function M.launch_tasks()
	insert_preview()
	local o = M.__tasks or {}
	picker.run_picker(o, function(entry) end)
end

return M
