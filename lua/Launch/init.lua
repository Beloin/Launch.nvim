local M = {}

function M.setup()
	vim.api.nvim_create_user_command("LoadLaunch", function(opts)
		local m = require("Launch.configure_dap")
		m.configure()
	end, {})

	vim.api.nvim_create_user_command("LoadLaunchDebug", function(opts)
		local m = require("Launch.configure_dap")
		m.debug()
	end, {})
end

return M
