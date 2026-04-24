local function map(mode, lhs, rhs, desc, opts)
	opts = opts or {}
	opts.desc = desc
	vim.keymap.set(mode, lhs, rhs, opts)
end

local function wrapped_movement(key)
	return function()
		if vim.v.count > 0 or not vim.wo.wrap then
			return key
		end

		return "g" .. key
	end
end

map("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear search highlight")

map("n", "n", "nzzzv", "Next search result")
map("n", "N", "Nzzzv", "Previous search result")
map("n", "<C-d>", "<C-d>zz", "Half-page down and center")
map("n", "<C-u>", "<C-u>zz", "Half-page up and center")

map("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, "Go to previous diagnostic")
map("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, "Go to next diagnostic")
map("n", "<leader>e", vim.diagnostic.open_float, "Show diagnostic message")
map("n", "<leader>q", vim.diagnostic.setloclist, "Populate location list with diagnostics")

map({ "n", "x" }, "j", wrapped_movement("j"), "Down", { expr = true })
map({ "n", "x" }, "k", wrapped_movement("k"), "Up", { expr = true })

map("v", "J", ":m '>+1<CR>gv=gv", "Move selection down")
map("v", "K", ":m '<-2<CR>gv=gv", "Move selection up")
map("v", "<", "<gv", "Indent left and reselect")
map("v", ">", ">gv", "Indent right and reselect")

map("n", "<C-h>", "<C-w><C-h>", "Focus left window")
map("n", "<C-l>", "<C-w><C-l>", "Focus right window")
map("n", "<C-j>", "<C-w><C-j>", "Focus lower window")
map("n", "<C-k>", "<C-w><C-k>", "Focus upper window")

map("n", "<leader>tf", "<cmd>FormatToggle<CR>", "[T]oggle auto[F]ormat")
map("n", ";", "<Esc>:", "Enter command-line mode", { nowait = true })

-- vim: ts=2 sts=2 sw=2 et
