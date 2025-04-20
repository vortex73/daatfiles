-- Enable faster Lua loading
vim.loader.enable()

-- LSP keymaps
local on_attach = function(client, bufnr)
	local bufopts = { noremap = true, silent = true, buffer = bufnr }

	-- Navigation
	vim.keymap.set('n', 'gD', ':FzfLua lsp_declarations<CR>', bufopts)
	vim.keymap.set('n', 'gd', ':FzfLua lsp_definitions<CR>', bufopts)
	vim.keymap.set('n', 'go', '<c-t>', bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

	-- Workspace
	vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)

	-- Code actions
	vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)

	-- Set some basic LSP highlights
	vim.api.nvim_set_hl(0, 'LspReferenceText', { underline = true })
	vim.api.nvim_set_hl(0, 'LspReferenceRead', { underline = true })
	vim.api.nvim_set_hl(0, 'LspReferenceWrite', { underline = true })
end

-- Setup capabilities with nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Load VSCode snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- Configure servers
local lspconfig = require('lspconfig')

-- Lua
lspconfig.lua_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			diagnostics = { globals = { 'vim' } },
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		}
	}
})

-- C/C++
lspconfig.clangd.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- TypeScript/JavaScript
lspconfig.ts_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		completions = {
			completeFunctionCalls = true
		}
	}
})

-- HTML
lspconfig.html.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Python
lspconfig.basedpyright.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- TailwindCSS
lspconfig.tailwindcss.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Emmet
lspconfig.emmet_language_server.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Zig
lspconfig.zls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Nim
lspconfig.nimls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Millet (if needed)
lspconfig.millet.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Java (special setup)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function()
		local jdtls = require("jdtls")

		-- Set the workspace directory
		local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
		local workspace_dir = "/home/vorrtt3x/.cache/jdtls/workspace/" .. project_name

		-- Config for JDTLS
		local config = {
			cmd = {
				"/usr/lib/jvm/java-23-openjdk/bin/java",
				"-Declipse.application=org.eclipse.jdt.ls.core.id1",
				"-Dosgi.bundles.defaultStartLevel=4",
				"-Declipse.product=org.eclipse.jdt.ls.core.product",
				"-Dlog.protocol=true",
				"-Dlog.level=ALL",
				"-Xmx1g",
				"--add-modules=ALL-SYSTEM",
				"--add-opens", "java.base/java.util=ALL-UNNAMED",
				"--add-opens", "java.base/java.lang=ALL-UNNAMED",
				"-jar", "/home/vorrtt3x/.java/java/jdtls/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar",
				"-configuration", "/home/vorrtt3x/.java/java/jdtls/config_linux",
				"-data", workspace_dir,
			},
			root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
			settings = { java = {} },
			init_options = { bundles = {} },
			on_attach = on_attach,
			capabilities = capabilities,
		}

		-- Start or attach JDTLS
		jdtls.start_or_attach(config)
	end,
})

-- Prettier setup
local prettier = require("prettier")
prettier.setup({
	bin = 'prettier',
	filetypes = {
		"css", "graphql", "html", "javascript", "javascriptreact",
		"json", "less", "markdown", "scss", "typescript", 
		"typescriptreact", "yaml",
	},
})

-- Setup nvim-cmp
local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup({
	completion = {
		completeopt = "menu,menuone,preview,noselect",
	},
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	formatting = {
		fields = {'abbr', 'kind', 'menu'},
		format = lspkind.cmp_format({
			mode = 'symbol',
			maxwidth = 50,
			ellipsis_char = '...',
		})
	},
	mapping = cmp.mapping.preset.insert({
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = false }), 
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, {'i', 's'}),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, {'i', 's'}),
	}),
	window = {
		documentation = {
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		},
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'path' },
	}, {
		{ name = 'buffer' },
	})
})

-- Setup autopairs
require('nvim-autopairs').setup()

-- Diagnostic configuration
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = false,
})

-- Customize diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
