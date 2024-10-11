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

--- Returns vim.inspect without methods/functions
---@param t table
function M.json_inspect(t)
	local filtered_tbl = {}
	if not t then
		return filtered_tbl
	end

	-- Iterate over the table and only include non-function entries
	for k, v in pairs(t) do
		if type(v) ~= "function" then
			filtered_tbl[k] = v
		end
	end

	-- Use vim.inspect to print the filtered table
	return vim.inspect(filtered_tbl)
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
