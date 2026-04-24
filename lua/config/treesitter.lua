local M = {}

local max_filesize = 200 * 1024
local languages = { "bash", "c", "lua", "markdown", "python", "query", "vim", "vimdoc" }
local textobjects = {
	af = "@function.outer",
	["if"] = "@function.inner",
	ac = "@class.outer",
	ic = "@class.inner",
	aa = "@parameter.outer",
	ia = "@parameter.inner",
}
local motions = {
	["]m"] = { method = "goto_next_start", query = "@function.outer" },
	["]]"] = { method = "goto_next_start", query = "@class.outer" },
	["[m"] = { method = "goto_previous_start", query = "@function.outer" },
	["[["] = { method = "goto_previous_start", query = "@class.outer" },
}

local function is_large_file(bufnr)
	local path = vim.api.nvim_buf_get_name(bufnr)
	if path == "" then
		return false
	end

	local stat = vim.uv.fs_stat(path)
	return stat and stat.size > max_filesize
end

local function start_treesitter(args)
	if is_large_file(args.buf) then
		return
	end

	local ok = pcall(vim.treesitter.start, args.buf)
	if not ok then
		return
	end

	if vim.bo[args.buf].filetype ~= "python" then
		vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end
end

local function setup_textobjects()
	require("nvim-treesitter-textobjects").setup({
		select = {
			lookahead = true,
		},
		move = {
			set_jumps = true,
		},
	})

	local select = require("nvim-treesitter-textobjects.select")
	local move = require("nvim-treesitter-textobjects.move")
	local swap = require("nvim-treesitter-textobjects.swap")

	for key, query in pairs(textobjects) do
		vim.keymap.set({ "x", "o" }, key, function()
			select.select_textobject(query, "textobjects")
		end, { desc = "Textobject: " .. query })
	end

	for key, config in pairs(motions) do
		vim.keymap.set({ "n", "x", "o" }, key, function()
			move[config.method](config.query, "textobjects")
		end, { desc = "Textobject move: " .. config.query })
	end

	vim.keymap.set("n", "<leader>cs", function()
		swap.swap_next("@parameter.inner")
	end, { desc = "[C]ode [S]wap next parameter" })

	vim.keymap.set("n", "<leader>cS", function()
		swap.swap_previous("@parameter.inner")
	end, { desc = "[C]ode [S]wap previous parameter" })
end

function M.setup()
	require("nvim-treesitter").setup({})
	setup_textobjects()

	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("config-treesitter", { clear = true }),
		pattern = languages,
		callback = start_treesitter,
	})
end

return M

-- vim: ts=2 sts=2 sw=2 et
