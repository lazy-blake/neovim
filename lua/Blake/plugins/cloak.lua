return {
	"laytan/cloak.nvim",
	config = function()
		require("cloak").setup({
			enabled = true,
			cloak_character = "*",
			highlight_group = "Comment",
			patterns = {
				{
					-- Environment files and config files
					file_pattern = {
						".env*",
						"wrangler.toml",
						".dev.vars",
					},
					cloak_pattern = "=.+",
				},
				{
					-- Python files - separate pattern
					file_pattern = "*.py",
					cloak_pattern = {
						'=%s*".*"', -- Matches = "anything"
						"=%s*'.*'", -- Matches = 'anything'
					},
				},
			},
		})
	end,
}
