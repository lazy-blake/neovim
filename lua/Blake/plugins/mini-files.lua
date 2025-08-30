return {
	"echasnovski/mini.files",
	config = function()
		local MiniFiles = require("mini.files")
		MiniFiles.setup({
			mappings = {
				go_in = "<CR>", -- Map both Enter and L to enter directories or open files
				go_in_plus = "L",
				go_out = "-",
				go_out_plus = "H",
				rename = "r",
			},
		})
		vim.keymap.set("n", "-", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" }) -- toggle file explorer
		vim.keymap.set("n", "<leader>-", function()
			MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
			MiniFiles.reveal_cwd()
		end, { desc = "Toggle into currently opened file" })
	end,
}
