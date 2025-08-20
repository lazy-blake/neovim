return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		-- "saghen/blink.cmp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "j-hui/fidget.nvim", config = true },
	},
	config = function()
		-- NOTE: LSP Keybinds
		-- Enhanced signature help configuration
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("LspSignatureHelp", { clear = true }),
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if client and client.server_capabilities.signatureHelpProvider then
					-- Auto-trigger signature help in insert mode
					vim.api.nvim_create_autocmd({ "CursorHoldI" }, {
						buffer = ev.buf,
						callback = function()
							local line = vim.api.nvim_get_current_line()
							local col = vim.api.nvim_win_get_cursor(0)[2]
							if col > 0 then
								local char = line:sub(col, col)
								local prev_char = line:sub(col - 1, col - 1)
								if char == "(" or prev_char == "(" or char == "," then
									vim.lsp.buf.signature_help()
								end
							end
						end,
					})
				end
			end,
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings
				-- Check `:help vim.lsp.*` for documentation on any of the below functions
				--
				local opts = { buffer = ev.buf, silent = true }

				-- keymaps
				opts.desc = "Show LSP references"
				vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				vim.keymap.set("n", "gdd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				vim.keymap.set({ "n", "v" }, "<leader>ca", function()
					vim.lsp.buf.code_action()
				end, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Show documentation for what is under cursor"
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

				vim.keymap.set("i", "<C-h>", function()
					vim.lsp.buf.signature_help()
				end, opts)
			end,
		})

		-- Define sign icons for each severity
		local signs = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
			[vim.diagnostic.severity.INFO] = " ",
		}

		-- Set the diagnostic config with all icons
		vim.diagnostic.config({
			signs = {
				text = signs, -- Enable signs in the gutter
			},
			virtual_text = true, -- Specify Enable virtual text for diagnostics
			underline = true, -- Specify Underline diagnostics
			update_in_insert = false, -- Keep diagnostics active in insert mode
		})

		-- Setup servers
		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Config lsp servers here
		-- lua_ls
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})

		-- emmet_language_server
		lspconfig.emmet_language_server.setup({
			capabilities = capabilities,
			filetypes = {
				"css",
				"eruby",
				"html",
				"javascript",
				"javascriptreact",
				"less",
				"sass",
				"scss",
				"pug",
				"typescriptreact",
			},
			init_options = {
				includeLanguages = {},
				excludeLanguages = {},
				extensionsPath = {},
				preferences = {},
				showAbbreviationSuggestions = true,
				showExpandedAbbreviation = "always",
				showSuggestionsAsSnippets = false,
				syntaxProfiles = {},
				variables = {},
			},
		})

		-- denols
		lspconfig.denols.setup({
			capabilities = capabilities,
			root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
		})

		-- ts_ls (replaces tsserver)
		lspconfig.ts_ls.setup({
			capabilities = capabilities,
			root_dir = function(fname)
				local util = lspconfig.util
				return not util.root_pattern("deno.json", "deno.jsonc")(fname)
					and util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git")(fname)
			end,
			single_file_support = false,
			init_options = {
				preferences = {
					includeCompletionsWithSnippetText = true,
					includeCompletionsForImportStatements = true,
				},
			},
		})

		-- Enhanced Python: pyright with comprehensive settings
		local function get_python_path()
			-- Check for virtual environment first
			local venv = vim.fn.getenv("VIRTUAL_ENV")
			if venv and venv ~= vim.NIL then
				return venv .. "/bin/python"
			end

			-- Check for conda environment
			local conda_env = vim.fn.getenv("CONDA_DEFAULT_ENV")
			if conda_env and conda_env ~= vim.NIL and conda_env ~= "base" then
				return vim.fn.getenv("CONDA_PREFIX") .. "/bin/python"
			end

			-- Fallback to system python (when no virtual environment is active)
			return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
		end

		lspconfig.pyright.setup({
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				-- Prevent LSP from handling formatting since conform does it
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false

				-- Enable signature help on function calls
				client.server_capabilities.signatureHelpProvider = {
					triggerCharacters = { "(", "," },
					retriggerCharacters = { "," },
				}
			end,
			settings = {
				python = {
					-- This is the new pythonPath setting that tells Pyright which Python interpreter to use
					pythonPath = get_python_path(),

					-- All these settings work together to give you comprehensive Python analysis
					analysis = {
						typeCheckingMode = "basic", -- How strict should type checking be
						autoImportCompletions = true, -- Automatically suggest imports
						autoSearchPaths = true, -- Automatically find Python packages
						useLibraryCodeForTypes = true, -- Analyze library source code for better completions
						diagnosticMode = "workspace", -- Analyze your entire project, not just open files

						-- These settings dramatically improve completion quality
						completeFunctionParens = true, -- Add parentheses when completing function names
						indexing = true, -- Build an index of your codebase for faster searches
						packageIndexDepths = {
							{
								name = "",
								depth = 2,
								includeAllSymbols = true, -- Include all available symbols in completions
							},
						},

						-- Paths for finding type information
						stubPath = "typings",
						typeshedPaths = {},
						extraPaths = {},
					},

					-- Linting configuration that works alongside completion
					linting = {
						enabled = true,
						pylintEnabled = false, -- Disable if you use other linters like ruff
						flake8Enabled = false,
						mypyEnabled = false,
					},
				},

				-- Global pyright settings that affect overall behavior
				pyright = {
					disableLanguageServices = false, -- Keep all language features enabled
					disableOrganizeImports = false, -- Allow Pyright to organize imports
				},
			},

			-- Root directory detection helps Pyright understand your project structure
			root_dir = function(fname)
				local util = lspconfig.util
				return util.root_pattern(
					"pyproject.toml", -- Modern Python project configuration
					"setup.py", -- Traditional Python package setup
					"setup.cfg", -- Alternative setup configuration
					"requirements.txt", -- Dependency specifications
					"Pipfile", -- Pipenv environment
					"pyrightconfig.json", -- Pyright-specific configuration
					".git" -- Git repository root
				)(fname)
			end,
			single_file_support = true, -- Allow Pyright to work on standalone Python files
		})
	end,
}
