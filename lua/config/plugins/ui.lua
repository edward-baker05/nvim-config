return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			local which_key = require("which-key")
			which_key.setup(opts)
			which_key.add({
				{ "<leader>c", group = "[C]ode" },
				{ "<leader>d", group = "[D]ocument" },
				{ "<leader>r", group = "[R]ename" },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>w", group = "[W]orkspace" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			})
		end,
	},
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
		init = function()
			vim.g.gruvbox_material_background = "soft"
			vim.g.gruvbox_material_enable_italic = false
		end,
		config = function()
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		"echasnovski/mini.nvim",
		lazy = false,
		config = function()
			require("mini.surround").setup({
				mappings = {
					add = "gza",
					delete = "gzd",
					find = "gzf",
					find_left = "gzF",
					highlight = "gzh",
					replace = "gzr",
					update_n_lines = "gzn",
				},
			})

			local statusline = require("mini.statusline")
			statusline.setup({
				use_icons = vim.g.have_nerd_font,
			})

			statusline["section_location"] = function()
				return "%2l:%-2v"
			end
		end,
	},
	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
	},
	{
		"mbbill/undotree",
		cmd = { "UndotreeToggle", "UndotreeShow" },
		keys = {
			{ "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle [U]ndotree" },
		},
	},
}

-- vim: ts=2 sts=2 sw=2 et
