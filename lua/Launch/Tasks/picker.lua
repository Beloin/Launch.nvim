--- picker.lua
local M = {}

local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local telescopeConfig = require("telescope.config")
local previewers = require("telescope.previewers")

local item_example = {
	{ name = "Item 1", preview = '{ name: "My Task 1",\n"pipeline": [ ... ] }' },
	{ name = "Item 2", preview = '{ name: "My Task 2",\n"pipeline": [ ... ] }' },
	{ name = "Item 3", preview = '{ name: "My Task 3",\n"pipeline": [ ... ] }' },
	{ name = "Item 4", preview = '{ name: "My Task 4",\n"pipeline": [ ... ] }' },
}

local function make_entry(item)
	return {
		value = item,
		display = item.name,
		ordinal = item.name, -- For fuzzy matching
	}
end

local function custom_previewer()
	return previewers.new_buffer_previewer({
		define_preview = function(self, entry, status)
			-- Clear the buffer first
			vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {})

			-- Display the hard-coded preview content for the selected item
			local content = entry.value.preview
			vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(content, "\n"))
		end,
	})
end

-- TODO: Make class or named table for this results
-- respecting { name, preview }
function M.run_picker(results)
	pickers
		.new({}, {
			prompt_title = "Tasks.nvim",
			finder = finders.new_table({
				-- results = results,
				results = item_example,
				entry_maker = function(item)
					return make_entry(item)
				end,
			}),
			preview = custom_previewer(),
			sorter = sorters.get_generic_fuzzy_sorter(),
			attach_mappings = function(_, map)
				map("i", "<CR>", actions.select_default)
				return true
			end,
		})
		:find()
end

return M
