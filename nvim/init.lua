-- Set <space> as the leader key
-- See `:h mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '

-- OPTIONS
--
-- See `:h vim.o`
-- NOTE: You can change these options as you wish!
-- For more options, you can see `:h option-list`
-- To see documentation for an option, you can use `:h 'optionname'`, for example `:h 'number'`
-- (Note the single quotes)

-- Line numbers
vim.o.number = true -- Show line numbers in a column.
vim.o.relativenumber = true -- Show line numbers relative to where the cursor is.

-- Sync clipboard between OS and Neovim. Schedule the setting after `UIEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:h 'clipboard'`
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.o.clipboard = 'unnamedplus'
  end,
})

-- Searching
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Interface
vim.o.cursorline = true -- Highlight the line where the cursor is on.
vim.o.scrolloff = 10 -- Keep this many screen lines above/below the cursor.
vim.o.list = true -- Show <tab> and trailing spaces.
vim.opt.colorcolumn = { 80 } -- Line length indicator
vim.o.splitright = true
vim.o.splitbelow = true

-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s). See `:h 'confirm'`
vim.o.confirm = true

-- Allow undos after exiting and reopening a file
vim.o.undofile = true

-- Tabbing
vim.o.expandtab = true -- Tabbing inserts spaces
vim.o.tabstop = 4 -- Render tabs as 4 spaces
vim.o.shiftwidth = 0 -- Inherit tabstop value for indent operations

-- Line wrapping
vim.o.wrap = false

-- CursorHold Execute Time
vim.o.updatetime = 500

-- Persist 'block' cursor
vim.o.guicursor = ''

-- KEYMAPS
--
-- See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
vim.keymap.set({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set({ 't', 'i' }, '<A-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set({ 'n' }, '<A-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<A-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<A-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<A-l>', '<C-w>l')

-- AUTOCOMMANDS (EVENT HANDLERS)
--
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- USER COMMANDS: DEFINE CUSTOM COMMANDS
--
-- See `:h nvim_create_user_command()` and `:h user-commands`

-- Create a command `:GitBlameLine` that print the git blame for the current line
vim.api.nvim_create_user_command('GitBlameLine', function()
  local line_number = vim.fn.line('.') -- Get the current line number. See `:h line()`
  local filename = vim.api.nvim_buf_get_name(0)
  print(vim.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }):wait().stdout)
end, { desc = 'Print the git blame for the current line' })

-- PLUGINS
--
-- See `:h :packadd`, `:h vim.pack`

-- Add the "nohlsearch" package to automatically disable search highlighting after
-- 'updatetime' and when going to insert mode.
vim.cmd('packadd! nohlsearch')

-- Install third-party plugins via "vim.pack.add()".
vim.pack.add({
  -- Quickstart configs for LSP
  'https://github.com/neovim/nvim-lspconfig',
  -- Fuzzy picker
  'https://github.com/ibhagwan/fzf-lua',
  -- Autocompletion
  'https://github.com/nvim-mini/mini.completion',
  -- Enhanced quickfix/loclist
  'https://github.com/stevearc/quicker.nvim',
  -- Git integration
  'https://github.com/lewis6991/gitsigns.nvim',
})

-- Initialize Plugins
require('fzf-lua').setup { fzf_colors = true }
require('mini.completion').setup {}
require('quicker').setup {}
require('gitsigns').setup {}

-- Plugin Keymaps
local fzf = require('fzf-lua')
vim.keymap.set('n', '<leader>ff', fzf.files,       { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', fzf.live_grep,   { desc = 'Grep project' })
vim.keymap.set('n', '<leader>fb', fzf.buffers,     { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fr', fzf.oldfiles,    { desc = 'Recent files' })
vim.keymap.set('n', '<leader>fh', fzf.help_tags,   { desc = 'Help' })
vim.keymap.set('n', '<leader>fk', fzf.keymaps,     { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>f/', fzf.blines,      { desc = 'Search current buffer' })

-- LSP
vim.keymap.set('n', 'gd',         fzf.lsp_definitions,        { desc = 'Go to definition' })
vim.keymap.set('n', 'gr',         fzf.lsp_references,         { desc = 'Find references' })
vim.keymap.set('n', '<leader>fs', fzf.lsp_document_symbols,   { desc = 'Document symbols' })
vim.keymap.set('n', '<leader>fd', fzf.diagnostics_document,   { desc = 'Document diagnostics' })

-- Git
vim.keymap.set('n', '<leader>gc', fzf.git_commits,   { desc = 'Git commits' })
vim.keymap.set('n', '<leader>gs', fzf.git_status,    { desc = 'Git status' })
vim.keymap.set('n', '<leader>gb', fzf.git_branches,  { desc = 'Git branches' })

