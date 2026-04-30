vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.termguicolors = true
vim.opt.confirm = true
vim.opt.splitkeep = "screen"

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

vim.opt.signcolumn = "yes"
vim.opt.updatetime = 200
vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = "split"

vim.opt.cursorline = true
vim.opt.scrolloff = 10

vim.opt.wrap = false
vim.opt.smoothscroll = true
vim.opt.virtualedit = "block"

if vim.fn.has("clipboard") == 1 then
	vim.opt.clipboard = "unnamedplus"
end

-- vim: ts=2 sts=2 sw=2 et
