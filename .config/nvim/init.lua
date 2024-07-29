vim.loader.enable()
require "paq" {
    "savq/paq-nvim",
    'sainnhe/sonokai',
    "FabijanZulj/blame.nvim",
    'christoomey/vim-tmux-navigator',
    'onsails/lspkind-nvim',
    'ibhagwan/fzf-lua',
    {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
    'hrsh7th/cmp-nvim-lsp',
    'windwp/nvim-autopairs',
    'hrsh7th/cmp-path',
    "lukas-reineke/indent-blankline.nvim",
    "neovim/nvim-lspconfig",
    "xiyaowong/transparent.nvim",
    'hrsh7th/nvim-cmp',
    "mbbill/undotree",
    'saadparwaiz1/cmp_luasnip',
    "rafamadriz/friendly-snippets",
    'L3MON4D3/LuaSnip',
    { "lervag/vimtex", opt = true },
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    'fedepujol/move.nvim',
    'nvim-lua/plenary.nvim',
    'epwalsh/obsidian.nvim',
}
require 'lsp'
require('blame').setup()
require('move').setup({
	line = {
		enable = true, -- Enables line movement
		indent = true  -- Toggles indentation
	},
	block = {
		enable = true, -- Enables block movement
		indent = true  -- Toggles indentation
	},
	word = {
		enable = true, -- Enables word movement
	},
	char = {
		enable = false -- Enables char movement
	}
})

require 'nvim-treesitter.configs'.setup{
    ensure_installed = {"c","cpp","lua","python","markdown","zig","nim","html","css"},
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<CR>',
            scope_incremental = '<CR>',
            node_incremental = '<TAB>',
            node_decremental = '<S-TAB>',
        },
    },
}

-- My Keybindings
vim.g.mapleader = " "
vim.keymap.set("n","<leader>tu",vim.cmd.UndotreeToggle)
vim.keymap.set("n","<leader>pv",vim.cmd.Ex)
vim.keymap.set('n', '<A-j>', ':MoveLine(1)<CR>', opts)
vim.keymap.set('n', '<A-k>', ':MoveLine(-1)<CR>', opts)
vim.keymap.set('n', '<A-h>', ':MoveHChar(-1)<CR>', opts)
vim.keymap.set('n', '<A-l>', ':MoveHChar(1)<CR>', opts)
vim.keymap.set('n', '<A-f>', ':MoveWord(1)<CR>', opts)
vim.keymap.set('n', '<A-b>', ':MoveWord(-1)<CR>', opts)
vim.keymap.set('v', '<A-j>', ':MoveBlock(1)<CR>', opts)
vim.keymap.set('v', '<A-k>', ':MoveBlock(-1)<CR>', opts)
vim.keymap.set('v', '<A-h>', ':MoveHBlock(-1)<CR>', opts)
vim.keymap.set('v', '<A-l>', ':MoveHBlock(1)<CR>', opts)
vim.keymap.set('n', '<C-h>', ':TmuxNavigateLeft<CR>',opts)
vim.keymap.set('n', '<C-l>', ':TmuxNavigateRight<CR>',opts)
vim.keymap.set('n', '<C-j>', ':TmuxNavigateDown<CR>',opts)
vim.keymap.set('n', '<C-k>', ':TmuxNavigateUp<CR>',opts)
vim.keymap.set('n', '<C-m>', ':FzfLua buffers<CR>', opts)
vim.keymap.set('n', '<C-g>', ':FzfLua live_grep<CR>', opts)
vim.keymap.set('n', '<leader>fs', ':FzfLua live_grep_resume<CR>', opts)
vim.keymap.set('n', '<leader>fw', ':FzfLua grep_curbuf<CR>', opts)
vim.keymap.set('n', '<leader>fq', ':FzfLua quickfix<CR>', opts)
vim.keymap.set('n', '<leader>ff', ':FzfLua git_status<CR>', opts)
vim.keymap.set('n', '<leader>fa', ':FzfLua lsp_code_actions<CR>', opts)
vim.keymap.set('n', '<leader>os', ':ObsidianSearch<CR>',opts)
vim.keymap.set('n', '<leader>on', ':ObsidianNew<CR>',opts)
vim.keymap.set('n', '<leader>ow', ':ObsidianWorkspace<CR>',opts)
vim.keymap.set("n", "<c-P>","<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
vim.keymap.set("i", "jk", "<ESC>", opts)
vim.keymap.set("n", "ty", ":nohl<CR>", opts)
vim.keymap.set('n', "gb", ":BlameToggle<CR>", opts)
vim.cmd.colorscheme('sonokai')
vim.opt.clipboard = "unnamedplus"
require('nvim-autopairs').setup()
require("ibl").setup()
vim.opt.guicursor = "i:block" 
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.backup =  false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 0
vim.opt.conceallevel = 1
vim.cmd('set tabstop=4')
vim.cmd('set shiftwidth=4')
vim.cmd('set expandtab')
vim.opt.laststatus = 0
