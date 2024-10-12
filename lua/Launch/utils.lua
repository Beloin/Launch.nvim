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
function M.json_inspect(t)
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

return M
