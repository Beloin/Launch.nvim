local M = {}

function M.setup()
	vim.api.nvim_create_user_command("LaunchLoad", function(opts)
		local m = require("Launch.configure_dap")
		m.configure()
	end, {})

	vim.api.nvim_create_user_command("LaunchDebug", function(opts)
		local m = require("Launch.configure_dap")
		m.debug()
	end, {})

	vim.api.nvim_create_user_command("LaunchTasksLoad", function(opts)
		local m = require("Launch.Tasks.init")
		m.configure()
	end, {})

	vim.api.nvim_create_user_command("LaunchTasks", function(opts)
		local m = require("Launch.Tasks.init")
		m.launch_tasks()
	end, {})
end

return M
