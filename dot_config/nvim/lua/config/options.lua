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

opt.updatetime = 250

-- keeping undo changes
opt.undofile = true

opt.clipboard = 'unnamedplus'

vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH
