# ⚡ Neovim Config

![Neovim](https://img.shields.io/badge/Neovim-0.9+-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![License](https://img.shields.io/github/license/lazy-blake/neovim?style=for-the-badge)
![Stars](https://img.shields.io/github/stars/lazy-blake/neovim?style=for-the-badge)
![Issues](https://img.shields.io/github/issues/lazy-blake/neovim?style=for-the-badge)
![Last Commit](https://img.shields.io/github/last-commit/lazy-blake/neovim?style=for-the-badge)

> ⚙️ A clean, modular, and modern Neovim configuration built with **Lua**, powered by **Lazy.nvim**. Ideal for developers, creatives, and power users who value performance, aesthetics, and extensibility.

---

## 🖼️ Preview

<p align="center">
  <img width="1911" height="1067" alt="Screenshot 2025-08-12 133236" src="https://github.com/user-attachments/assets/e2807a33-836a-476d-8a6c-5cef151ba960" />
</p>


> ✨ Featuring `snacks.nvim` + `ascii-image-converter` powered dashboard with live ASCII art preview!

---

## 📦 Plugin Highlights

| Feature              | Plugin(s) Involved |
|----------------------|--------------------|
| 🚀 Lazy Loading       | [`lazy.nvim`](https://github.com/folke/lazy.nvim) |
| 🎨 UI / Theme         | `dressing.nvim`, `bufferline.nvim`, `lualine.nvim`, `noice.nvim` |
| 📦 LSP Support        | `nvim-lspconfig`, `mason.nvim`, `null-ls`, `nvim-cmp` |
| 🧠 Treesitter         | `nvim-treesitter` |
| 🌈 Indentation + UI   | `indent-blankline.nvim`, `which-key.nvim` |
| 📁 File Explorer      | `nvim-tree.lua` |
| 💡 Code Enhancements | `auto-pairs`, `todo-comments`, `flash.nvim`, `render-markdown` |
| 🎨 Custom Dashboard   | `snacks.nvim` with ASCII preview integration |
| 💻 Dev Utilities      | `undo-tree`, `tailwind-tools`, `bufferline`, `sessions`, `wilder` |

---

## 🧠 How It's Structured

```

nvim/
├── after/ftplugin            # File-specific config
├── lua/
│   └── Blake/                # All custom Lua config
│       ├── core/             # Core: keymaps, options, base init
│       └── plugins/          # Plugin configs (LSP, UI, utilities)
|       └── custom/           # Quotes config for the dashboard
├── init.lua                  # Entry point (loads Blake.core and plugins)
├── lazy-lock.json            # Lazy.nvim plugin lockfile

````

Modular, easy to maintain and extend.

---

## 🚀 Setup & Installation

### Requirements

- **Neovim 0.9+**
- **Nerd Font** (like FiraCode Nerd Font)
- Optional: [`ascii-image-converter`](https://github.com/TheZoraiz/ascii-image-converter) for ASCII art dashboard

### Install

```bash
git clone https://github.com/lazy-blake/neovim ~/.config/nvim
````

Launch Neovim and Lazy will handle the rest:

```bash
nvim
```

---

## 📸 Dashboard Customization

You can show an image in ASCII on the dashboard with:
"C:\Users\akash\OneDrive\Pictures\Screenshots\Screenshot 2025-08-07 140803.png"
```lua
cmd = "ascii-image-converter path/to/image.jpg -C"
```

Use the `snacks.lua` plugin config to modify preview and menu styles. Place your image in a local path and point to it inside your snacks configuration.

---

## 📚 Plugin Management (Lazy.nvim)

You can manage plugins using Lazy's built-in commands:

```lua
-- Press <leader>l to open Lazy.nvim UI
```

To update all plugins:

```
:Lazy update
```

---

## 💡 Inspirations

* [LazyVim](https://github.com/LazyVim/LazyVim)
* [NvChad](https://github.com/NvChad/NvChad)

---

## 📝 License

This config is open-sourced under the [MIT License](LICENSE).

---

> Made with ❤️ by [@lazy-blake](https://github.com/lazy-blake)



