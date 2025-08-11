vim.cmd("let g:netrw_banner = 0") -- disable the banner for inbuild explorer

vim.opt.nu = true -- to enable the numbers
vim.opt.relativenumber = true -- to enable the line numbers
vim.o.shadafile = "NONE"

vim.opt.tabstop = 4 -- enable tab as 4 spaces
vim.opt.softtabstop = 4
vim.opt.expandtab = true -- convert tabs into spaces
vim.opt.shiftwidth = 4 -- specify how many spaces it shoud indent to , when you are indenting something
vim.opt.autoindent = true -- enable autoindent and smart indent
vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true -- with this you can undo even after quiting neovim

vim.opt.incsearch = true --highlights matches as you type your search
vim.opt.inccommand = "split"
vim.opt.ignorecase = true --Makes searches case-insensitive by default.
vim.opt.smartcase = true -- Makes search case-sensitive only if your search pattern contains uppercase letters.

vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.scrolloff = 8 -- to add padding where you scroll (8 lines visible above and below)
vim.opt.signcolumn = "yes" -- Prevents text shifting left/right when signs (like errors or Git changes) appear.

vim.opt.backspace = { "start", "eol", "indent" } -- to make the backspace button behave more naturally

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.updatetime = 50
vim.opt.colorcolumn = ""

vim.opt.clipboard:append("unnamedplus")
vim.opt.hlsearch = true -- highlight the search

vim.opt.mouse = "a"

vim.g.editorconfig = true
