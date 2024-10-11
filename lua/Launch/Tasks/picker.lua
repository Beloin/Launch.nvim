--- picker.lua
local M = {}

local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local previewers = require("telescope.previewers")
local action_state = require("telescope.actions.state")

local noice = require("noice")

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
		define_preview = function(self, entry)
			-- Clear the buffer first
			vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {})

			-- Display the hard-coded preview content for the selected item
			local content = entry.value.preview
			vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(content, "\n"))
		end,
	})
end

local function on_item_selected(entry)
	noice.notify("Entry selected: " .. entry.value.name, "info", {})
end

-- TODO: Add text to the upper block, add working preview

--- Run picker calling callback
---@param results ItemExample[]
---@param callback fun(itemExample: ItemExample)
function M.run_picker(results, callback)
	pickers
		.new({}, {
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

					-- TODO: Remove when finished debugging
					on_item_selected(entry)
					if callback then
						print("Calling callback...")
						callback(entry.value)
					end
				end)

				return true
			end,
		})
		:find()
end

return M
