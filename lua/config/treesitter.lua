local M = {}

local max_filesize = 200 * 1024
-- Parser names to keep installed (the `main` branch ignores `ensure_installed`
-- in setup(), so we install these explicitly below).
local ensure_installed = {
	"bash",
	"c",
	"lua",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"rust",
	"toml",
	"typst",
	"vim",
	"vimdoc",
}
-- Filetypes for which to start treesitter. These are buffer filetypes, which
-- differ from a couple of parser names (sh<->bash, help<->vimdoc); markdown_inline
-- is injected by the markdown parser so it needs no filetype entry.
local filetypes = { "sh", "c", "lua", "markdown", "python", "query", "rust", "toml", "typst", "vim", "help" }
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

	-- Fold options are window-local, so set them here (per window showing a
	-- treesitter buffer) rather than once at startup.
	vim.wo.foldmethod = "expr"
	vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
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

local function install_missing()
	local installed = {}
	for _, lang in ipairs(require("nvim-treesitter.config").get_installed()) do
		installed[lang] = true
	end

	local missing = {}
	for _, lang in ipairs(ensure_installed) do
		if not installed[lang] then
			table.insert(missing, lang)
		end
	end

	if #missing > 0 then
		require("nvim-treesitter").install(missing)
	end
end

function M.setup()
	-- On the `main` branch setup() only takes `install_dir`; parser installation
	-- and highlighting are handled explicitly.
	install_missing()
	setup_textobjects()

	-- Open files with everything unfolded; folds are still available to toggle.
	vim.o.foldlevelstart = 99
	vim.o.foldenable = true

	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("config-treesitter", { clear = true }),
		pattern = filetypes,
		callback = start_treesitter,
	})
end

return M

-- vim: ts=2 sts=2 sw=2 et
