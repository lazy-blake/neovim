return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "j-hui/fidget.nvim", config = true },
	},
	config = function()
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
				local opts = { buffer = ev.buf, silent = true }

				-- keymaps
				opts.desc = "Show LSP references"
				vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

				opts.desc = "Show LSP definitions"
				vim.keymap.set("n", "gdd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"
				vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				vim.keymap.set({ "n", "v" }, "<leader>ca", function()
					vim.lsp.buf.code_action()
				end, opts)

				opts.desc = "Smart rename"
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

				opts.desc = "Show documentation for what is under cursor"
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

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
				text = signs,
			},
			virtual_text = true,
			underline = true,
			update_in_insert = false,
		})

		-- Get capabilities for autocompletion
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()
		local lspconfig_util = require("lspconfig").util

		-- Enhanced Python path detection
		local function get_python_path()
			local venv = vim.fn.getenv("VIRTUAL_ENV")
			if venv and venv ~= vim.NIL then
				return venv .. "/bin/python"
			end

			local conda_env = vim.fn.getenv("CONDA_DEFAULT_ENV")
			if conda_env and conda_env ~= vim.NIL and conda_env ~= "base" then
				return vim.fn.getenv("CONDA_PREFIX") .. "/bin/python"
			end

			return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
		end

		-- Configure LSP servers using the new vim.lsp.config API

		-- Lua Language Server
		vim.lsp.config["lua_ls"] = {
			cmd = { "lua-language-server" },
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
		}

		-- Emmet Language Server
		vim.lsp.config["emmet_language_server"] = {
			cmd = { "emmet-language-server", "--stdio" },
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
		}

		-- Deno Language Server
		vim.lsp.config["denols"] = {
			cmd = { "deno", "lsp" },
			capabilities = capabilities,
			root_markers = { "deno.json", "deno.jsonc" },
		}

		-- TypeScript Language Server
		vim.lsp.config["ts_ls"] = {
			cmd = { "typescript-language-server", "--stdio" },
			capabilities = capabilities,
			root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
			single_file_support = false,
			init_options = {
				preferences = {
					includeCompletionsWithSnippetText = true,
					includeCompletionsForImportStatements = true,
				},
			},
		}

		-- CSS Language Server
		vim.lsp.config["cssls"] = {
			cmd = { "vscode-css-language-server", "--stdio" },
			capabilities = capabilities,
			settings = {
				css = {
					validate = true,
					lint = {
						unknownAtRules = "ignore",
					},
				},
				scss = {
					validate = true,
					lint = {
						unknownAtRules = "ignore",
					},
				},
				less = {
					validate = true,
					lint = {
						unknownAtRules = "ignore",
					},
				},
			},
		}

		-- Pyright Language Server
		vim.lsp.config["pyright"] = {
			cmd = { "pyright-langserver", "--stdio" },
			capabilities = capabilities,
			settings = {
				python = {
					pythonPath = get_python_path(),
					analysis = {
						typeCheckingMode = "basic",
						autoImportCompletions = true,
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "openFilesOnly",
						completeFunctionParens = true,
						indexing = true,
						stubPath = "typings",
						typeshedPaths = {},
						extraPaths = {},
					},
					linting = {
						enabled = true,
						pylintEnabled = false,
						flake8Enabled = false,
						mypyEnabled = false,
					},
				},
				pyright = {
					disableLanguageServices = false,
					disableOrganizeImports = false,
				},
			},
			root_markers = {
				"pyproject.toml",
				"setup.py",
				"setup.cfg",
				"requirements.txt",
				"Pipfile",
				"pyrightconfig.json",
				".git",
			},
			single_file_support = true,
		}

		-- Enable all LSP servers
		vim.lsp.enable({
			"lua_ls",
			"emmet_language_server",
			"denols",
			"ts_ls",
			"cssls",
			"pyright",
		})

		-- Custom logic for TypeScript vs Deno (since vim.lsp.enable doesn't support conditional logic)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
			callback = function()
				local fname = vim.api.nvim_buf_get_name(0)
				if fname == "" then
					return
				end

				-- Check if this is a Deno project
				local is_deno = lspconfig_util.root_pattern("deno.json", "deno.jsonc")(fname)

				if is_deno then
					-- Stop ts_ls if running and ensure denols is running
					vim.lsp.stop_client(vim.lsp.get_clients({ name = "ts_ls" }))
				else
					-- Stop denols if running and ensure ts_ls is running
					vim.lsp.stop_client(vim.lsp.get_clients({ name = "denols" }))
				end
			end,
		})
	end,
}
