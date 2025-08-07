local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(

    {
        {import = "Blake.plugins"},
        {import = "Blake.plugins.lsp"}
    },
    {   -- checking for updates automatically and turning off the notifications
        checker = {
            enabled = true,
            notify = false,
        },
    }
)
