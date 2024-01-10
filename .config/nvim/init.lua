vim.loader.enable()
require "paq" {
    "savq/paq-nvim",
    'sainnhe/sonokai',
    'onsails/lspkind-nvim',
    {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
    'hrsh7th/cmp-nvim-lsp',
    'windwp/nvim-autopairs',
    'fedepujol/move.nvim',
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
}
require 'lsp'
vim.g.mapleader = " "
vim.keymap.set("n","<leader>tf",vim.cmd.FloatermToggle)
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
vim.keymap.set("i", "jk", "<ESC>", opts)
vim.cmd.colorscheme('sonokai')
vim.opt.clipboard = "unnamedplus"
vim.api.nvim_set_option("clipboard","unnamed")
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
vim.cmd('set tabstop=4')
vim.cmd('set shiftwidth=4')
vim.cmd('set expandtab')
vim.opt.laststatus = 0
