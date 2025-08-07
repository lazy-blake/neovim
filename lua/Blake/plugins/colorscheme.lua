return {

  {
    "sainnhe/gruvbox-material",
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_enable_italic = true
      vim.cmd.colorscheme("gruvbox-material") -- just change the name to change the colorscheme
    end,
  },
    -- can add as many colorscheme you want here
  { "sainnhe/everforest", enabled = true, lazy = true },
  { "sainnhe/sonokai", enabled = true, lazy = true },
  { "shaunsingh/solarized.nvim", enabled = true, lazy = true },
  { "folke/tokyonight.nvim", enabled = true, lazy = true },
  { "catppuccin/nvim", enabled = true, lazy = true },

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
