local yank_group = vim.api.nvim_create_augroup("config-highlight-yank", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = yank_group,
	callback = function()
		vim.highlight.on_yank()
	end,
})

local checktime_group = vim.api.nvim_create_augroup("config-checktime", { clear = true })

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	desc = "Refresh file contents when changed outside of Neovim",
	group = checktime_group,
	callback = function()
		if vim.fn.mode() ~= "c" then
			vim.cmd.checktime()
		end
	end,
})

-- vim: ts=2 sts=2 sw=2 et
