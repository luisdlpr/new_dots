-- intended for nvim v0.9.5
require("luisdlpr.plugins")
require("luisdlpr.remap")

vim.opt.clipboard = "unnamedplus"
vim.opt.wrap = true

-- indentation
vim.opt.shiftwidth = 4   -- >>
vim.opt.tabstop = 4      -- <Tab>
vim.opt.expandtab = true -- convert tabs to spaces

-- line marker
vim.opt.number = true
vim.opt.colorcolumn = "80"

-- case insensitive search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- context label
vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
