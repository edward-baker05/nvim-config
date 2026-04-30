vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true

vim.keymap.set("n", "<leader>tp", function()
	require("config.markpad").toggle()
end, { buffer = 0, desc = "[T]oggle [P]review in Markpad" })

-- vim: ts=2 sts=2 sw=2 et
