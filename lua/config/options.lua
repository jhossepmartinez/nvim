local opt = vim.opt -- for conciseness

-- Line Number
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- Tabs & Indentation
opt.tabstop = 4
opt.shiftwidth = 4 
opt.expandtab = true 
opt.autoindent = true 

-- Wrapping
opt.wrap = false 

-- Search Settings
opt.ignorecase = true 
opt.smartcase = true 

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- Backspace
opt.backspace = "indent,eol,start" 

-- Clipboard
opt.clipboard:append("unnamedplus")
