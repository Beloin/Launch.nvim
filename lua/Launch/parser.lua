local M = {}

M.__current_table = nil

local function parse()
	local cwd = vim.fn.getcwd()
	local lJson = io.open(cwd .. "/launch.nvim")

	local table = nil
	if lJson then
		local content = lJson:read("*all")
		lJson:close()

		table = vim.json.decode(content)
	else
		local lJson2 = io.open(cwd .. "/.vscode/launch.nvim")
		if lJson2 then
			local content = lJson2:read("*all")
			lJson2:close()

			table = vim.json.decode(content)
		end
	end

	return table
end

local function read_args()
	local table = parse()
	if not table then
		return nil
	end

	local args = table["configurations"][1]["args"]
	return args
end

local function cache_read_args(table)
	if not table then
		return nil
	end

	local args = table["configurations"][1]["args"]
	return args
end

M.parse = function()
	M.__current_table = parse()
	return M.__current_table
end

M.get_args = function()
	return cache_read_args(M.__current_table)
end

M.get_type = function() end

M.should_preprocess = nil
M.get_pipeline = nil

-- TODO: Not necessary right now?
M.get_run = nil
M.get_program = nil

return M
