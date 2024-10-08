local Task = require("Launch.Tasks.Task")
local M = {}

M.__current_table = nil

function M.reset()
	M.__current_table = nil
end

--- Load tasks from launch.nvim
---@param launch_nvim table
---@return boolean
function M.load_tasks(launch_nvim)
	if not launch_nvim then
		return false
	end

	local tasks = launch_nvim["tasks"]

	if tasks and #tasks >= 1 then
		M.__current_table = tasks
		return true
	end

	return false
end

--- Get the list of tasks
---@return boolean
---@return table?
function M.get_tasks()
	if not M.__current_table then
		return false, nil
	end

	local tasks = {}
	for _, value in ipairs(M.__current_table) do
		local task = Task:new(value["name"], value["pipeline"])
		table.insert(tasks, task)
	end

	return true, tasks
end

return M
