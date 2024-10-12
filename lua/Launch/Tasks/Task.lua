local utils = require "Launch.utils"
local Task = {}

function Task:new(name, pipeline)
	local o = {}
	o.name = name
	o.pipeline = pipeline
	setmetatable(o, self)
	setmetatable(o, {
		__tostring = function(t)
			return t.name .. ", Pipeline #" .. #t.pipeline
		end,
	})
	return o
end


function Task:repr()
  return utils.dump(self)
end

return Task
