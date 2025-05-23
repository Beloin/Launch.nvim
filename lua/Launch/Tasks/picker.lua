--- picker.lua
local M = {}

local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local previewers = require("telescope.previewers")
local action_state = require("telescope.actions.state")

---@class ItemExample
---@field name string
---@field preview string Buffer Like viewer
---@field [string] any
local ItemExample = { name = "My task N°1", preview = '{ name: "My Task 1",\n"pipeline": [ ... ] }' }

local function make_entry(item)
	return {
		value = item,
		display = item.name,
		ordinal = item.name,
	}
end

local function custom_previewer()
	return previewers.new_buffer_previewer({
		define_preview = function(self, entry, _)
			-- Clear the buffer first
			vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {})

			local content = entry.value.preview or "No preview available"
			vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(content, "\n"))

			-- Configure Buffer information
			vim.bo[self.state.bufnr].filetype = "lua"
			vim.bo[self.state.bufnr].modifiable = false
		end,
		-- Vars added to self.state
		setup = function(_)
			return {}
		end,
		dynamic_preview_title = true,
		dyn_title = function(self, entry)
			return entry.value.name
		end,
	})
end

--- Run picker calling callback
---@param results ItemExample[]
---@param on_pick fun(itemExample: ItemExample)
function M.run_picker(results, on_pick)
	pickers
		.new({
			layout_strategy = "horizontal",
			layout_config = {
				preview_width = 0.5,
			},
		}, {
			prompt_title = "Tasks.nvim",
			finder = finders.new_table({
				results = results,
				entry_maker = function(item)
					return make_entry(item)
				end,
			}),
			sorter = sorters.get_generic_fuzzy_sorter(),
			previewer = custom_previewer(),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					local entry = action_state.get_selected_entry()
					actions.close(prompt_bufnr)

					if on_pick then
						on_pick(entry.value)
					end
				end)

				return true
			end,
		})
		:find()
end

return M
