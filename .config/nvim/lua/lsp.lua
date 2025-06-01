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
local luasnip = require('luasnip')

cmp.setup({
    completion = {
        completeopt = "menu,menuone,preview,noselect",
    },
	experimental = {
		ghost_text = true,
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
        ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({
                    select = true,
                })
            else
                fallback()
            end
        end),
        ["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
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
