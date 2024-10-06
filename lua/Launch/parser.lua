local M = {}

M.__current_table = nil
M.__current_index = 1

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

local function cache_read_type(table)
	if not table then
		return nil
	end
	return table["configurations"][M.__current_index]["type"]
end

local function cache_read_run(table)
	if not table then
		return nil
	end

	return table["configurations"][M.__current_index]["run"]
end

local function cache_read_pipeline(table)
	if not table then
		return nil
	end

	local pipeline = table["configurations"][M.__current_index]["pipeline"]

	return pipeline
end

local function cache_read_args(table)
	if not table then
		return nil
	end

	local args = table["configurations"][M.__current_index]["args"]
	return args
end

local function cache_read_program(table)
	if not table then
		return nil
	end
	local program = table["configurations"][M.__current_index]["program"]
	if not program then
		return nil
	end

	local fullPath = vim.fn.getcwd() .. "/./" .. program

	return vim.fn.resolve(fullPath)
end

local function cache_read_env(table)
	if not table then
		return nil
	end
	return table["configurations"][M.__current_index]["env"]
end

local function cache_get_lang(table)
	if not table then
		return nil
	end
	return table["configurations"][M.__current_index]["lang"]
end

local function cache_get_name(table)
	if not table then
		return nil
	end
	return table["configurations"][M.__current_index]["name"]
end

M.load = function()
	M.__current_table = parse()
	return M.__current_table
end

M.is_loaded = function()
	return M.__current_table ~= nil
end

M.get_args = function()
	return cache_read_args(M.__current_table)
end

M.get_type = function()
	return cache_read_type(M.__current_table)
end

M.should_preprocess = function()
	local p = cache_read_pipeline(M.__current_table)
	return p ~= nil and #p > 1
end

M.get_pipeline = function()
	return cache_read_pipeline(M.__current_table)
end

-- TODO: Not necessary right now?
M.get_run = function()
	return cache_read_run(M.__current_table)
end

M.get_program = function()
	return cache_read_program(M.__current_table)
end

-- TODO: For now everything will be "Launch"
M.get_request = function()
	return "launch"
end

M.get_env = function()
	return cache_read_env(M.__current_table)
end

M.get_lang = function()
	return cache_get_lang(M.__current_table)
end

M.get_name = function()
	return cache_get_name(M.__current_table)
end

function M.reset()
	M.__current_table = nil
	M.__current_index = 1
end

function M.get_config_size()
	if M.__current_table then
		return #M.__current_table["configurations"]
	end

	return 0
end

function M.set_index(i)
	if M.__current_table then
		M.__current_index = i
	end
end

return M
