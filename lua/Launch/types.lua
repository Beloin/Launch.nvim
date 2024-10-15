--- types.lua
local M = {}

--- DapConfig type
--- @class DapConfig
--- @field name string
--- @field request string
--- @field type string
--- @field program function
--- @field args function | string | string[]
--- @field cwd function
---
--- @field pipeline function
--- @field setenv function
M.DapConfig = {}

return M
