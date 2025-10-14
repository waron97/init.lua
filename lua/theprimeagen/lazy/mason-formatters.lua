return {
	"williamboman/mason.nvim",
	opts = {
		ensure_installed = {
			-- Formatters
			"prettier",
			"stylua",
			"clang-format",
			"ruff_format",
			"black",
		},
	},
}
