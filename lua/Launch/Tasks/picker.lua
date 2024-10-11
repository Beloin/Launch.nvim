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

			-- Display the hard-coded preview content for the selected item
			-- local content = entry.value.preview
			local content = "Move it upppppp"
			vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(content, "\n"))
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

-- TODO: Add text to the upper block, add working preview

--- Run picker calling callback
---@param results ItemExample[]
---@param on_pick fun(itemExample: ItemExample)
function M.run_picker(results, on_pick)
	pickers
		.new({
			preview = custom_previewer(),
		}, {
			prompt_title = "Tasks.nvim",
			finder = finders.new_table({
				results = results,
				entry_maker = function(item)
					return make_entry(item)
				end,
			}),
			preview = custom_previewer(),
			sorter = sorters.get_generic_fuzzy_sorter(),
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
