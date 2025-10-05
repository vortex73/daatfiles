vim.loader.enable()
require "paq" {
	"savq/paq-nvim",
	"nvim-treesitter/nvim-treesitter-context",
	'voldikss/vim-floaterm',
	'voldikss/fzf-floaterm',
	'knubie/vim-kitty-navigator',
	'MunifTanjim/prettier.nvim',
	 'rebelot/kanagawa.nvim',
	"FabijanZulj/blame.nvim",
	'onsails/lspkind-nvim',
	'ibhagwan/fzf-lua',
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
	'fedepujol/move.nvim',
	"mfussenegger/nvim-dap",
	"rcarriga/nvim-dap-ui",
	"nvim-neotest/nvim-nio",
	"theHamsta/nvim-dap-virtual-text",
	{ 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
}

require("prettier").setup({
	bin = 'prettier',
	filetypes = {
		"css", "javascript", "typescript", "json", "graphql", "markdown"
	}
})

local luasnip = require('luasnip')
require('fzf-lua').register_ui_select()
local function get_git_root()
  local git_dir = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if vim.v.shell_error == 0 then
    return git_dir
  else
    return vim.fn.getcwd()
  end
end


vim.g.loaded_python3_provider = 1

local disabled_built_ins = {
	"gzip", "zip", "zipPlugin", "tar", "tarPlugin", "getscript", "getscriptPlugin",
	"vimball", "vimballPlugin", "2html_plugin", "logipat", "netrw", "netrwPlugin", "matchparen"
}

for _, plugin in pairs(disabled_built_ins) do
	vim.g["loaded_" .. plugin] = 1
end

local opts = { noremap = true, silent = true }

require'treesitter-context'.setup{
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  multiwindow = false, -- Enable multiwindow support.
  max_lines = 4, -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to show for a single context
  trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20, -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

require 'lsp'
local dap = require('dap')
local dapui = require('dapui')
dapui.setup()
require('nvim-dap-virtual-text').setup()
dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-dap', -- or '/usr/bin/lldb-vscode' on some systems
    name = 'lldb'
}
dap.configurations.c = {
    {
        name = 'Launch',
        type = 'lldb', -- or 'codelldb' if using CodeLLDB
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
    },
}
dap.configurations.cpp = dap.configurations.c

vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '➡️', texthl = 'DapStopped', linehl = 'DebugLineHL', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '🔶', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '⚠️', texthl = 'DapBreakpoint', linehl = '', numhl = '' })

dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end
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
-- require('kitty-scrollback').setup()
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

vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end, { desc = "Toggle Breakpoint", noremap = true, silent = true })
vim.keymap.set('n', '<leader>dc', function() dap.continue() end, { desc = "Continue", noremap = true, silent = true })
vim.keymap.set('n', '<leader>ds', function() dap.step_over() end, { desc = "Step Over", noremap = true, silent = true })
vim.keymap.set('n', '<leader>di', function() dap.step_into() end, { desc = "Step Into", noremap = true, silent = true })
vim.keymap.set('n', '<leader>do', function() dap.step_out() end, { desc = "Step Out", noremap = true, silent = true })
vim.keymap.set('n', '<leader>dr', function() dap.repl.open() end, { desc = "Open REPL", noremap = true, silent = true })
vim.keymap.set('n', '<leader>dl', function() dap.run_last() end, { desc = "Run Last", noremap = true, silent = true })
vim.keymap.set('n', '<leader>dt', function() dap.terminate() end, { desc = "Terminate", noremap = true, silent = true })
vim.keymap.set('n', '<leader>du', function() dapui.toggle() end, { desc = "Toggle DAP UI", noremap = true, silent = true })

-- Fzf KeyMaps
vim.keymap.set('n', '<leader>fg', ":FzfLua grep<CR>", { desc = "Search (grep) in CWD", noremap = true, silent = true })
vim.keymap.set('n', '<leader>fw', ":FzfLua grep_cword<CR>", { desc = "Search current word", noremap = true, silent = true })
vim.keymap.set('v', '<leader>fv', ":FzfLua grep_visual<CR>", { desc = "Search visual selection", noremap = true, silent = true })
vim.keymap.set('n', '<leader>fR', ":FzfLua live_grep_resume<CR>", { desc = "Resume last grep", noremap = true, silent = true })
vim.keymap.set('n', '<leader>fb', ":FzfLua grep_curbuf<CR>", { desc = "Search in current buffer", noremap = true, silent = true })
vim.keymap.set('n', '<leader>fl', ":FzfLua live_grep<CR>", { desc = "Live grep", noremap = true, silent = true })
vim.keymap.set('n', '<leader>fk', ":FzfLua keymaps<CR>", { desc = "Show this Menu", noremap = true, silent = true })
vim.keymap.set('n', '<leader>ff', ":FzfLua files<CR>", { desc = "Files in cwd", noremap = true, silent = true })
vim.keymap.set('n', '<leader>fp', function()
  require("fzf-lua").live_grep({ cwd = get_git_root() })
end, { desc = "Grep through project (CWD)", noremap = true, silent = true })

vim.keymap.set('n', '<leader>fs', ':FzfLua lsp_document_symbols<CR>',opts)
vim.keymap.set('n', '<leader>fS', ':FzfLua lsp_workspace_symbols<CR>',opts)
vim.keymap.set('n', '<leader>fr', ':FzfLua lsp_references<CR>',opts)
vim.keymap.set('n', '<leader>fi', ':FzfLua lsp_incoming_calls<CR>',opts)
vim.keymap.set('n', '<leader>fI', ':FzfLua lsp_implementations<CR>',opts)
vim.keymap.set('n', '<leader>fo', ':FzfLua lsp_outgoing_calls<CR>',opts)
vim.keymap.set('n', '<leader>fF', ':FzfLua lsp_finder<CR>',opts)

vim.keymap.set("n","<leader>tu",vim.cmd.UndotreeToggle)
vim.keymap.set("n","<leader>pv",vim.cmd.Ex)
vim.keymap.set('n', '<A-j>', ':MoveLine(1)<CR>', opts)
vim.keymap.set('n', '<A-k>', ':MoveLine(-1)<CR>', opts) vim.keymap.set('n', '<A-h>', ':MoveWord(1)<CR>', opts)
vim.keymap.set('n', '<A-l>', ':MoveWord(-1)<CR>', opts)
vim.keymap.set('v', '<A-j>', ':MoveBlock(1)<CR>', opts)
vim.keymap.set('v', '<A-k>', ':MoveBlock(-1)<CR>', opts)
vim.keymap.set('n', '<C-h>', ':TmuxNavigateLeft<CR>',opts)
vim.keymap.set('n', '<C-l>', ':TmuxNavigateRight<CR>',opts)
vim.keymap.set('n', '<C-j>', ':TmuxNavigateDown<CR>',opts)
vim.keymap.set('n', '<C-k>', ':TmuxNavigateUp<CR>',opts)
vim.keymap.set('n', '<leader>fq', ':FzfLua quickfix<CR>', opts)
vim.keymap.set('n', '<leader>fa', ':FzfLua lsp_code_actions<CR>', opts)
vim.keymap.set("n", "<c-P>","<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
vim.keymap.set("i", "jk", "<ESC>", opts)
vim.keymap.set("n", "ty", ":nohl<CR>", opts)
vim.keymap.set('n', "gb", ":BlameToggle<CR>", opts)
vim.keymap.set('n', "gi", ":Precognition toggle<CR>", opts)
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })
-- vim.cmd.colorscheme('sonokai')
require('kanagawa').setup({
    undercurl = true,
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true},
    statementStyle = { bold = true },
    typeStyle = {},
    variablebuiltinStyle = { italic = true},
    specialReturn = true,
    specialException = true,
    -- transparent = true,
    -- dimInactive = false,
    colors = {},
    theme = "wave" -- Available: "default", "wave", "lotus", "dragon"
})
vim.keymap.set('n', '<leader>tt', ':FloatermToggle<CR>', { desc = "Toggle terminal", noremap = true, silent = true })
vim.keymap.set('t', '<C-q>q', '<C-\\><C-n>:FloatermToggle<CR>', { desc = "Toggle terminal", noremap = true, silent = true })
-- vim.keymap.set('t', '<C-q>s', '<C-\\><C-n>:Floaterms<CR>', { desc = "Switch terminal", noremap = true, silent = true })
-- vim.keymap.set('t', '<leader>tt', '<C-\\><C-n>:FloatermToggle<CR>', { desc = "Toggle terminal", noremap = true, silent = true })
-- vim.keymap.set('n', '<leader>tn', ':FloatermNew<CR>', { desc = "New terminal", noremap = true, silent = true })
-- vim.keymap.set('n', '<leader>ts', ':Floaterms<CR>', { desc = "Switch terminal", noremap = true, silent = true })
-- vim.keymap.set('t', '<leader>ts', '<C-\\><C-n>:Floaterms<CR>', { desc = "Switch terminal", noremap = true, silent = true })
vim.g.floaterm_position = 'center'
vim.g.floaterm_width = 0.9
vim.g.floaterm_height = 0.8
vim.g.floaterm_borderchars = '─│─│╭╮╯╰'



vim.cmd.colorscheme('kanagawa')
vim.opt.clipboard = "unnamedplus"
require('nvim-autopairs').setup()
require("ibl").setup()
vim.cmd [[set cmdheight=0]]
vim.keymap.set("n", "<leader>ch", function()
  if vim.o.cmdheight == 0 then
    vim.o.cmdheight = 1
  else
    vim.o.cmdheight = 0
  end
end, { desc = "Toggle cmdheight" })

vim.lsp.inlay_hint.enable()
vim.opt.foldcolumn = "0"
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
-- vim.opt.listchars = { tab = "».", trail = "~", extends= "→" ,precedes= "←",nbsp= "+" }
-- vim.opt.list = true
vim.api.nvim_set_hl(0, 'Tab', { fg = '#D3D3D3' })
-- Mapping for ;; (search and replace with no prompt)
vim.api.nvim_set_keymap('n', ';;', ':%s:::g<Left><Left><Left>', { noremap = true, silent = false })
-- Mapping for ;' (search and replace with confirmation)
vim.api.nvim_set_keymap('n', ";'", ":%s:::cg<Left><Left><Left><Left>", { noremap = true, silent = false })
vim.cmd('set tabstop=4')
vim.cmd('set shiftwidth=4')
vim.cmd('set inccommand=split')
-- vim.cmd('set expandtab')
-- vim.opt.laststatus = 0
local function trim_whitespace()
  local save_cursor = vim.fn.winsaveview()
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.fn.winrestview(save_cursor)
end
vim.opt.list = true
vim.opt.listchars = {
  tab = "  ",
  nbsp = "␣",
  trail = "•",
  extends = "⟩",
  precedes = "⟨"
}

vim.api.nvim_set_hl(0, 'Whitespace', { fg = '#444444' })
vim.api.nvim_set_hl(0, 'SpecialKey', { fg = '#666666' })

vim.api.nvim_create_user_command('TrimWhitespace', trim_whitespace, {})

vim.keymap.set('n', '<leader>tw', trim_whitespace, { desc = "Trim trailing whitespace", noremap = true, silent = true })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "none", fg = "#ffffff" })

