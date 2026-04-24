local function fzf(name, opts)
	return function()
		require("fzf-lua")[name](opts or {})
	end
end

local harpoon_keys = {
	{
		"<leader>a",
		function()
			require("harpoon"):list():add()
		end,
		desc = "Add file to harpoon",
	},
	{
		"<leader>A",
		function()
			local harpoon = require("harpoon")
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end,
		desc = "Toggle harpoon menu",
	},
}

for index = 1, 9 do
	table.insert(harpoon_keys, {
		"<leader>" .. index,
		function()
			require("harpoon"):list():select(index)
		end,
		desc = "Go to harpoon file " .. index,
	})
end

return {
	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		opts = {
			"default-title",
			fzf_colors = true,
			fzf_opts = {
				["--no-scrollbar"] = true,
			},
			defaults = {
				formatter = "path.filename_first",
			},
		},
		config = function(_, opts)
			local fzf = require("fzf-lua")
			fzf.setup(opts)
			fzf.register_ui_select()
		end,
		keys = {
			{ "<leader>sh", fzf("help_tags"), desc = "[S]earch [H]elp" },
			{ "<leader>sk", fzf("keymaps"), desc = "[S]earch [K]eymaps" },
			{ "<leader>sf", fzf("files"), desc = "[S]earch [F]iles" },
			{ "<leader>ss", fzf("builtin"), desc = "[S]earch [S]elect fzf-lua" },
			{ "<leader>sw", fzf("grep_cword"), desc = "[S]earch current [W]ord" },
			{ "<leader>sg", fzf("live_grep"), desc = "[S]earch by [G]rep" },
			{ "<leader>sd", fzf("diagnostics_document"), desc = "[S]earch [D]iagnostics" },
			{ "<leader>sr", fzf("resume"), desc = "[S]earch [R]esume" },
			{ "<leader>s.", fzf("oldfiles"), desc = '[S]earch Recent Files ("." for repeat)' },
			{ "<leader><leader>", fzf("buffers"), desc = "[ ] Find existing buffers" },
			{ "<leader>/", fzf("blines"), desc = "[/] Fuzzily search in current buffer" },
			{
				"<leader>s/",
				fzf("lines"),
				desc = "[S]earch [/] in Open Files",
			},
			{
				"<leader>sn",
				fzf("files", { cwd = vim.fn.stdpath("config") }),
				desc = "[S]earch [N]eovim files",
			},
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		cmd = "Neotree",
		keys = {
			{
				"<leader>te",
				function()
					vim.cmd("Neotree toggle filesystem reveal left")
				end,
				desc = "[T]oggle [E]xplorer sidebar",
			},
			{
				"<C-e>",
				function()
					vim.cmd("Neotree toggle filesystem reveal left")
				end,
				desc = "Toggle explorer",
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
			"antosha417/nvim-lsp-file-operations",
		},
		opts = {
			log_to_file = false,
			close_if_last_window = true,
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,
			filesystem = {
				follow_current_file = {
					enabled = true,
				},
				use_libuv_file_watcher = true,
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
				},
			},
			window = {
				position = "left",
				width = 30,
				mappings = {
					["<space>"] = "none",
					["P"] = { "toggle_preview", config = { use_float = false } },
				},
			},
		},
	},
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {},
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = harpoon_keys,
		opts = {},
		config = function(_, opts)
			local harpoon = require("harpoon")

			harpoon:setup(opts)
			harpoon:extend({
				UI_CREATE = function(cx)
					vim.keymap.set("n", "<C-v>", function()
						harpoon.ui:select_menu_item({ vsplit = true })
					end, { buffer = cx.bufnr, desc = "Open harpoon entry in vsplit" })

					vim.keymap.set("n", "<C-x>", function()
						harpoon.ui:select_menu_item({ split = true })
					end, { buffer = cx.bufnr, desc = "Open harpoon entry in split" })

					vim.keymap.set("n", "<C-t>", function()
						harpoon.ui:select_menu_item({ tabedit = true })
					end, { buffer = cx.bufnr, desc = "Open harpoon entry in tab" })
				end,
			})
		end,
	},
}

-- vim: ts=2 sts=2 sw=2 et
