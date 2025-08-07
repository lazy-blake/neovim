local opt = { noremap = true, silent = true } -- disable recursive mapping , enable silent so that the commands doesnt show up

-- maping leader to space for global and local
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" }) -- vim.keymap.set({mode}, {lhs}, {rhs}, {options})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "join current line with the line below" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "move down in buffer with currsor centerd" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "move down in buffer with currsor centerd" })

-- for indentation
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "paste without loosing clipboard content" })

-- remember yanked
vim.keymap.set("v", "p", '"_dp', opts) -- prevent pasting to replacing my clipboared
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "delete without copying" })

-- ctrl c as escape cuz Im lazy to reach up to the esc key
vim.keymap.set("i", "<C-c>", "<Esc>")

-- format without prettier using the built in
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Unmaps Q in normal mode
vim.keymap.set("n", "Q", "<nop>")

-- delete certain character without copying it to clipboard
vim.keymap.set("n", "x", '"_x', opts)

vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word, cursor is on globally. Can change every instances of that word in that buffer" }
)

-- Executes shell command from in here making file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "makes file executable" })

-- highlight after yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "highlight the text after copying it",
	group = vim.api.nvim_create_augroup("yank-highlight", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- tab stuff
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>") --open new tab
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>") --close current tab
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>") --go to next
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>") --go to pre

-- split management
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- to run python files
vim.keymap.set("n", "<leader>r", function()
	local file = vim.fn.expand("%")
	if vim.bo.filetype == "python" then
		vim.cmd("belowright split | terminal python " .. file) --NOTE: if you are on mac then change it to python3
		vim.cmd("startinsert")
	else
		vim.notify("Not a Python file", vim.log.levels.WARN)
	end
end, { desc = "Run Python file in terminal" })
