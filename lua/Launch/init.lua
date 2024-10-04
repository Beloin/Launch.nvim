local M = {}

function M.setup() end
vim.api.nvim_create_user_command("Launch.nvim", function(opts)
	local m = require("Launch.configure_dap")
  m.configure()
end, {})

return M
