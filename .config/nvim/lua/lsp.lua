-- lsp keymaps
local on_attach = function(client, bufnr)
	local bufopts = {noremap=true, silent=true, buffer=bufnr}
	vim.keymap.set('n', 'gD', ':FzfLua lsp_declarations<CR>', bufopts)
	vim.keymap.set('n', 'gd', ':FzfLua lsp_definitions<CR>', bufopts)
	vim.keymap.set('n', 'go', '<c-t>', bufopts)
	vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
end

-- random variable creation
local lsp_zero = require('lsp-zero')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("luasnip.loaders.from_vscode").lazy_load()
local lua_opts = lsp_zero.nvim_lua_ls()

local prettier = require("prettier")

prettier.setup({
	bin = 'prettier', -- or `'prettierd'` (v0.23.3+)
	filetypes = {
		"css",
		"graphql",
		"html",
		"javascript",
		"javascriptreact",
		"json",
		"less",
		"markdown",
		"scss",
		"typescript",
		"typescriptreact",
		"yaml",
	},
})

-- configured servers

require('lspconfig').clangd.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}
require('lspconfig').millet.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}
require('lspconfig').emmet_language_server.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}
require('lspconfig').tailwindcss.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}
-- require('lspconfig').tsserver.setup {
	--     on_attach = on_attach,
	--     capabilities = capabilities,
	-- }
	require('lspconfig').html.setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}
	require('lspconfig').pyright.setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}
	require('lspconfig').zls.setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}
	require('lspconfig').nimls.setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}
	require('lspconfig').ts_ls.setup{
		on_attach = on_attach,
		settings = {
			completions = {
				completeFunctionCalls = true
			}
		},
		capabilities = capabilities,
	}
	require'lspconfig'.html.setup{
		on_attach = on_attach,
		capabilities = capabilities,
	}
	require('lspconfig').lua_ls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		settings = { -- custom settings for lua
			Lua = {
				-- make the language server recognize "vim" global
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					-- make language server aware of runtime files
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.stdpath("config") .. "/lua"] = true,
					},
				},
			},
		},
	})

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
					"-jar","/home/vorrtt3x/.java/java/jdtls/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar",
					"-configuration", "/home/vorrtt3x/.java/java/jdtls/config_linux",
					"-data", workspace_dir,
				},
				root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
				settings = {
					java = {},
				},
				init_options = {
					bundles = {}, -- Add debugger bundles here if needed
				},
			}

			-- Start or attach JDTLS
			jdtls.start_or_attach(config)
		end,
	})
	require("obsidian").setup({
		workspaces = {
			{
				name = "personal",
				path = "~/vaults/personal",
			},
			{
				name = "musings",
				path = "~/dev/writeups/",
			},
			{
				name = "pesnotes",
				path = "~/pes/notes/",
			},
		},

	})
	local cmp = require'cmp'
	local lspkind = require 'lspkind'
	local cmp_action = require('lsp-zero').cmp_action()
	cmp.setup({
		completion = {
			completeopt = "menu,menuone,preview,noselect",

		},
		snippet = {
			expand = function(args)
				require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			end,
		},
		formatting = {
			fields = {'abbr', 'kind', 'menu'},
			format = require('lspkind').cmp_format({
				mode = 'symbol',
				maxwidth = 50,
				ellipsis_char = '...',
			})
		},
		-- snippet window keymaps
		mapping = cmp.mapping.preset.insert({
			['<C-u>'] = cmp.mapping.scroll_docs(-4),
			['<C-d>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-f>'] = cmp_action.luasnip_jump_forward(),
			['<C-b>'] = cmp_action.luasnip_jump_backward(),
			['<C-e>'] = cmp.mapping.abort(),
			['<CR>'] = cmp.mapping.confirm({ select = false}), 
			['<Tab>'] = cmp_action.luasnip_supertab(),
			['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
		}),
		window = {
			documentation = {
				border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
			},
		},
		sources = cmp.config.sources({
			{ name = 'nvim_lsp' },
			{ name = 'luasnip' }, 
			{name = 'path' },
		}, {
			{ name = 'buffer' },
		})
	})
