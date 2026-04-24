if vim.loader then
	vim.loader.enable()
end

for _, plugin in ipairs({
	"gzip",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"rplugin",
	"tarPlugin",
	"tutor_mode_plugin",
	"zipPlugin",
}) do
	vim.g["loaded_" .. plugin] = 1
end

vim.g.loaded_tohtml_plugin = 1
vim.g.loaded_remote_plugins = 1
vim.g.loaded_spellfile_plugin = 1

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = vim.g.have_nerd_font ~= false

require("config")

-- vim: ts=2 sts=2 sw=2 et
