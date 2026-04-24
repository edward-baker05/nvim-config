return {
	"tpope/vim-sleuth",
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = function()
			return {
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")
					local function map(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
					end

					map("n", "]h", function()
						gitsigns.nav_hunk("next")
					end, "Next hunk")
					map("n", "[h", function()
						gitsigns.nav_hunk("prev")
					end, "Previous hunk")
					map("n", "<leader>hs", gitsigns.stage_hunk, "Git [H]unk [S]tage")
					map("n", "<leader>hr", gitsigns.reset_hunk, "Git [H]unk [R]eset")
					map("v", "<leader>hs", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, "Git [H]unk [S]tage")
					map("v", "<leader>hr", function()
						gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, "Git [H]unk [R]eset")
					map("n", "<leader>hS", gitsigns.stage_buffer, "Git [H]unk [S]tage buffer")
					map("n", "<leader>hu", gitsigns.undo_stage_hunk, "Git [H]unk [U]ndo stage")
					map("n", "<leader>hR", gitsigns.reset_buffer, "Git [H]unk [R]eset buffer")
					map("n", "<leader>hp", gitsigns.preview_hunk_inline, "Git [H]unk [P]review")
					map("n", "<leader>hb", function()
						gitsigns.blame_line({ full = true })
					end, "Git [H]unk [B]lame line")
				end,
			}
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		main = "ibl",
		opts = {
			scope = {
				enabled = true,
				show_start = true,
				show_end = false,
				highlight = { "Function", "Label" },
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			require("config.treesitter").setup()
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			enable = true,
			max_lines = 3,
			multiline_threshold = 20,
			mode = "cursor",
			trim_scope = "outer",
			zindex = 20,
		},
	},
}

-- vim: ts=2 sts=2 sw=2 et
