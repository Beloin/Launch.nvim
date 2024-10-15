local M = {}

local noice = require("noice")

function M.dump(o)
	if type(o) == "table" then
		local s = "{ "
		for k, v in pairs(o) do
			if type(k) ~= "number" then
				k = '"' .. k .. '"'
			end
			s = s .. "[" .. k .. "] = " .. M.dump(v) .. ","
		end
		return s .. "} "
	else
		return tostring(o)
	end
end

--- Returns the string representation of arr
---@param t table
---@param br string?
function M.dump_arr(t, br)
	br = br or "["
	local out = br .. " "
	for index, v in ipairs(t) do
		out = out .. tostring(v)
		if index ~= #t then
			out = out .. ", "
		end
	end

	return out .. " " .. br
end

--- Recursively formats a table, indenting according to the nesting level.
---@param t table
---@param level number
---@return string
local function recursive_inspect(t, level)
	local out = ""
	local indent = string.rep("\t", level) -- Indentation based on nesting level

	if type(t) == "table" then
		out = out .. "{\n"
		for k, v in pairs(t) do
			local key = type(k) == "string" and k .. " = " or "" -- Handle keys
			-- Check if the value is a table (to handle nested arrays)
			if type(v) == "table" then
				out = out .. indent .. key .. recursive_inspect(v, level + 1) .. ",\n"
			else
				out = out .. indent .. key .. vim.inspect(v) .. ",\n"
			end
		end
		out = out .. string.rep("\t", level - 1) .. "}"
	else
		out = out .. vim.inspect(t)
	end

	return out
end

--- Returns vim.inspect without methods/functions
---@param t table
---@return string
function M.lua_inspect(t)
	if not t then
		return "{}"
	end

	return recursive_inspect(t, 1)
end

function M.run_sh(command)
	local handle = io.popen(command)
	if not handle then
		return false, nil
	end

	local result = handle:read("*a")
	handle:close()

	return true, result
end

function M.notify_status(msg)
	noice.notify(msg, "info", { title = "Launch.nvim" })
end

function M.notify_error(msg)
	noice.notify(msg, "error", { title = "Launch.nvim" })
end

function M.notify_debug(msg)
	noice.notify(msg, "debug", { title = "Launch.nvim" })
end


--- Shallow Copy a table
---@param in_t table
---@param out_t table?
---@param exclude_opts string[]?
---@return table
function M.shallow_copy(in_t, out_t, exclude_opts)
	if out_t == nil then
		out_t = {}
	end
  if exclude_opts == nil then
    exclude_opts = {}
  end

  local newexc_opts = {}
  for _, value in ipairs(exclude_opts) do
    newexc_opts[value] = true
  end

	for k, v in pairs(in_t) do
    if newexc_opts[k] then
      goto continue
    end

		out_t[k] = v

	    ::continue::
	end

	return out_t
end

--- Scan a directory
---@param directory string
---@return string[]
function M.scandir(directory)
	local i, t, popen = 0, {}, io.popen
	local pfile = popen('ls -a "' .. directory .. '"')
	if pfile == nil then
		return {}
	end

	for filename in pfile:lines() do
		i = i + 1
		t[i] = filename
	end
	pfile:close()
	return t
end

return M
