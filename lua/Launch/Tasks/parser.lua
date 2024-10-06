local M = {}

M.__current_table = nil
M.__current_index = 1

function M.reset()
	M.__current_table = nil
	M.__current_index = 1
end

return M
