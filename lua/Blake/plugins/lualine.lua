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
		}

		local branch = { "branch", icon = { "", color = { fg = "#A6D4DE" } }, "|" }

		-- default battery-nvim config
		--NOTE: check https://github.com/justinhj/battery.nvim repo for more info
		local battery = require("battery")

		battery.setup({
			update_rate_seconds = 30, -- Number of seconds between checking battery status
			show_status_when_no_battery = true, -- Don't show any icon or text when no battery found (desktop for example)
			show_plugged_icon = true, -- If true show a cable icon alongside the battery icon when plugged in
			show_unplugged_icon = true, -- When true show a diconnected cable icon when not plugged in
			show_percent = true, -- Whether or not to show the percent charge remaining in digits
			vertical_icons = true, -- When true icons are vertical, otherwise shows horizontal battery icon
			multiple_battery_selection = 1, -- Which battery to choose when multiple found. "max" or "maximum", "min" or "minimum" or a number to pick the nth battery found (currently linux acpi only)
		})

		local nvimbattery = {
			function()
				return require("battery").get_status_line()
			end,
			color = { fg = colors.color2, bg = colors.color3 },
		}

		lualine.setup({
			icons_enabled = true,
			options = {
				theme = my_lualine_theme,
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "|", right = "|" },
			},
			sections = {
				lualine_a = { mode },
				lualine_b = { branch },
				lualine_c = { diff, filename },
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
					nvimbattery,
				},
				--NOTE: to show the clock, you can remove this line if you dont want that
				lualine_z = { "time" },
			},
		})
	end,
}
