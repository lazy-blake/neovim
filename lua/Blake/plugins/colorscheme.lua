return {

	{
		"sainnhe/gruvbox-material",
		enabled = true,
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_enable_italic = true
		end,
	},
	-- can add as many colorscheme you want here
	{ "sainnhe/everforest", enabled = true, lazy = true },
	{ "sainnhe/sonokai", enabled = true, lazy = true },
	{ "shaunsingh/solarized.nvim", enabled = true, lazy = true },
	{ "folke/tokyonight.nvim", enabled = true, lazy = true },
	{ "catppuccin/nvim", enabled = true, lazy = true },
	{ "everviolet/nvim", name = "evergarden", enabled = true, lazy = true },
	{ "xero/miasma.nvim", enabled = true, lazy = true },
	{ "uloco/bluloco.nvim", enabled = true, lazy = true, dependencies = { "rktjmp/lush.nvim" } },
	{
		"Alexis12119/nightly.nvim",
		name = "nightly", -- Good practice to name your colorscheme
		lazy = false, -- Colorschemes should load on startup
		priority = 1000, -- Make sure it loads before other plugins
		config = function()
			-- 1. Load the colorscheme
			vim.cmd.colorscheme("nightly")

			--    This code will run every time the colorscheme is set.
			vim.api.nvim_set_hl(0, "DashboardQuote", { link = "String", italic = true })
			vim.api.nvim_set_hl(0, "DashboardTitle", { link = "Title" })
		end,
	},

	{
		-- this takes the wallpaper color and convert it into neovim colorscheme
		"arizzoni/wal.nvim",
		enabled = true,
		lazy = true,
		config = function()
			vim.g.wal_path = "$HOME/.cache/wal/colors.json"
		end,
	},
}
