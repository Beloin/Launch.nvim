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
