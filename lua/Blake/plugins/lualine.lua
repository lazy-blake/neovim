return {
	"nvim-lualine/lualine.nvim",

	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"justinhj/battery.nvim", -- for showing battery percentage
		"iamvladw/lualine-time.nvim",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		local colors = {
			color0 = "#1d2021", -- dark background
			color1 = "#fb4934", -- red (replace)
			color2 = "#b8bb26", -- green (insert)
			color3 = "#3c3836", -- dark gray (statusline bg)
			color4 = "#fabd2f", -- yellow (optional)
			color5 = "#d3869b", -- purple/pink
			color6 = "#a89984", -- light gray (inactive fg)
			color7 = "#83a598", -- blue (normal)
			color8 = "#fe8019", -- orange (visual)
		}
		local my_lualine_theme = {
			replace = {
				a = { fg = colors.color0, bg = colors.color1, gui = "bold" },
				b = { fg = colors.color2, bg = colors.color3 },
			},
			inactive = {
				a = { fg = colors.color6, bg = colors.color3, gui = "bold" },
				b = { fg = colors.color6, bg = colors.color3 },
				c = { fg = colors.color6, bg = colors.color3 },
			},
			normal = {
				a = { fg = colors.color0, bg = colors.color7, gui = "bold" },
				b = { fg = colors.color2, bg = colors.color3 },
				c = { fg = colors.color2, bg = colors.color3 },
			},
			visual = {
				a = { fg = colors.color0, bg = colors.color8, gui = "bold" },
				b = { fg = colors.color2, bg = colors.color3 },
			},
			insert = {
				a = { fg = colors.color0, bg = colors.color2, gui = "bold" },
				b = { fg = colors.color2, bg = colors.color3 },
			},
		}

		local mode = {
			"mode",
			fmt = function(str)
				-- return ' '
				-- displays only the first character of the mode
				return " " .. str
			end,
		}
		local diagnostics = {
			"diagnostics",
			sources = { "nvim_diagnostic" },
			sections = { "error", "warn" },
			symbols = { error = " ", warn = " ", info = " ", hint = " " },
			colored = true,
			update_in_insert = true,
			always_visible = true,
		}

		local diff = {
			"diff",
			colored = true,
			symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
			-- cond = hide_in_width,
		}

		local filename = {
			"filename",
			file_status = true,
			path = 0,
			colored = true,
		}

		local branch = { "branch", icon = { "", color = { fg = "#A6D4DE" } }, "|" }

		lualine.setup({
			icons_enabled = true,
			options = {
				theme = "nightly",
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "|", right = "|" },
			},
			sections = {
				lualine_a = { mode },
				lualine_b = { branch },
				lualine_c = { diff, filename, diagnostics },
				lualine_x = {
					{
						-- require("noice").api.statusline.mode.get,
						-- cond = require("noice").api.statusline.mode.has,
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					-- { "encoding",},
					-- { "fileformat" },
					{ "filetype" },
				},
				--NOTE: to show the clock, you can remove this line if you dont want that
				lualine_z = { "time" },
			},
		})
	end,
}
