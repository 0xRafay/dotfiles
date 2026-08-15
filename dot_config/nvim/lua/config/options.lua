-- Options
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.guicursor = { 'a:block' }

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.scrolloff = 10

opt.ignorecase = true
opt.smartcase = true
opt.termguicolors = true
opt.signcolumn = 'yes'

-- disable nvim intro
opt.shortmess:append "sI"

opt.updatetime = 500
-- vim.o.timeoutlen = 300

-- keeping undo changes
opt.undofile = true

opt.clipboard = 'unnamedplus'

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has('win32') ~= 0
local sep = is_windows and '\\' or '/'
local delim = is_windows and ';' or ':'
vim.env.PATH = table.concat({ vim.fn.stdpath('data'), 'mason', 'bin' }, sep) .. delim .. vim.env.PATH
