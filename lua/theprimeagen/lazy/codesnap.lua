return {
	"mistricky/codesnap.nvim",
	build = "make",
	keys = {
		{ "<leader>cs", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
	},
	opts = {
		save_path = "~/Pictures/Screenshots/CSN",
		has_breadcrumbs = true,
		bg_theme = "bamboo",
	},
}
