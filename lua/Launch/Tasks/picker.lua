local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local telescopeConfig = require("telescope.config")


local item_example = {
  { name = 'Item 1', preview = '{ name: "My Task 1",\n"pipeline": [ ... ] }' },
  { name = 'Item 2', preview = '{ name: "My Task 2",\n"pipeline": [ ... ] }' },
  { name = 'Item 3', preview = '{ name: "My Task 3",\n"pipeline": [ ... ] }' },
  { name = 'Item 4', preview = '{ name: "My Task 4",\n"pipeline": [ ... ] }' },
}


local function run_picker(results)
	pickers
		.new({}, {
			prompt_title = "Tasks.nvim",
			finder = finders.new_table({
				results = {
					"Item 1",
					"Item 2",
					"Item 3",
          "Item 4",
				},
			}),
			sorter = sorters.get_generic_fuzzy_sorter(),
			attach_mappings = function(_, map)
				map("i", "<CR>", actions.select_default)
				return true
			end,
		})
		:find()
end
