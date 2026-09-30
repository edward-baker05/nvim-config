return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			notify_on_error = true,
			format_on_save = {
				lsp_fallback = true,
				timeout_ms = 3000, -- Gives black and isort 3 seconds to finish
			},
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				c = { "clang-format" },
				cpp = { "clang-format" },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = {
					registries = {
						"github:mason-org/mason-registry",
						"github:Crashdummyy/mason-registry",
					},
				},
			},
			"williamboman/mason-lspconfig.nvim",
			{
				"WhoIsSethDaniel/mason-tool-installer.nvim",
				opts = {
					ensure_installed = { "clang-format" },
				},
			},
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			local lsp = require("config.lsp")
			local capabilities = lsp.capabilities()

			lsp.setup()

			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "pyright", "clangd", "tinymist" },
				-- rustaceanvim owns rust_analyzer; stop mason-lspconfig from
				-- also enabling it, which would attach a second client.
				automatic_enable = {
					exclude = { "rust_analyzer" },
				},
			})

			for server_name, config in pairs(lsp.servers(capabilities)) do
				vim.lsp.config(server_name, config)
				vim.lsp.enable(server_name)
			end
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^9",
		lazy = false,
		config = function()
			-- rustaceanvim configures the builtin rust_analyzer client itself,
			-- so do NOT add rust_analyzer to config.lsp.servers(). Settings are
			-- passed through the vim.g.rustaceanvim table instead of setup().
			vim.g.rustaceanvim = {
				server = {
					-- Use the same completion capabilities as every other server
					-- so blink.cmp behaves identically in Rust buffers.
					capabilities = require("config.lsp").capabilities(),
					default_settings = {
						["rust-analyzer"] = {
							-- Run clippy instead of plain `cargo check` for diagnostics
							-- so more lints surface as you work.
							check = {
								command = "clippy",
							},
						},
					},
				},
			}

			-- Buffer-local Rust keymaps under <leader>r so :RustLsp isn't needed.
			-- These only exist in Rust buffers, so they cannot clash globally;
			-- <leader>rn is left for the standard LSP rename set in config.lsp.
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("config-rustaceanvim", { clear = true }),
				pattern = "rust",
				callback = function(event)
					local bufnr = event.buf

					local ok, which_key = pcall(require, "which-key")
					if ok then
						which_key.add({ { "<leader>r", group = "[R]ust", buffer = bufnr } })
					end

					local function map(lhs, action, desc)
						vim.keymap.set("n", lhs, function()
							vim.cmd.RustLsp(action)
						end, { buffer = bufnr, desc = "Rust: " .. desc })
					end

					map("<leader>ra", "codeAction", "Code [a]ction (grouped)")
					map("<leader>rr", "runnables", "[R]unnables")
					map("<leader>rt", "testables", "[T]estables")
					map("<leader>rd", "debuggables", "[D]ebuggables")
					map("<leader>re", "expandMacro", "[E]xpand macro")
					map("<leader>rp", "parentModule", "[P]arent module")
					map("<leader>rc", "openCargo", "Open [C]argo.toml")
					map("<leader>rD", "renderDiagnostic", "Explain [D]iagnostic")

					vim.keymap.set("n", "<leader>rh", function()
						vim.cmd.RustLsp({ "hover", "actions" })
					end, { buffer = bufnr, desc = "Rust: [H]over actions" })
				end,
			})
		end,
	},
	{
		"tarides/ocaml.nvim",
		ft = { "ocaml", "ocaml_interface", "menhir", "ocamllex", "dune" },
		config = function()
			-- Custom keymaps disable all plugin defaults, so every key is listed.
			-- Everything lives under <leader>o to avoid the <leader>c/s/t groups.
			require("ocaml").setup({
				keymaps = {
					jump_next_hole = "<leader>on",
					jump_prev_hole = "<leader>oN",
					construct = "<leader>oc",
					jump = "<leader>oj",
					phrase_prev = "<leader>opp",
					phrase_next = "<leader>opn",
					infer = "<leader>oi",
					switch_ml_mli = "<leader>os",
					type_enclosing = "<leader>ot",
					type_enclosing_grow = "<Up>",
					type_enclosing_shrink = "<Down>",
					type_enclosing_increase = "<Right>",
					type_enclosing_decrease = "<Left>",
				},
			})
		end,
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"rcarriga/nvim-dap-ui",
				dependencies = { "nvim-neotest/nvim-nio" },
			},
		},
		keys = {
			{ "<F5>", function() require("dap").continue() end, desc = "DAP: Continue/Start" },
			{ "<F10>", function() require("dap").step_over() end, desc = "DAP: Step over" },
			{ "<F11>", function() require("dap").step_into() end, desc = "DAP: Step into" },
			{ "<F12>", function() require("dap").step_out() end, desc = "DAP: Step out" },
			{ "<F6>", function() require("dapui").toggle() end, desc = "DAP: Toggle UI" },
			{ "<leader>b", function() require("dap").toggle_breakpoint() end, desc = "DAP: Toggle [b]reakpoint" },
			{
				"<leader>B",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "DAP: Conditional [B]reakpoint",
			},
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()

			-- Open/close the UI automatically with the debug session.
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
			-- rustaceanvim auto-detects the Mason-installed codelldb and wires up
			-- the Rust adapter, so no manual dap.adapters config is needed here.
			-- Use :RustLsp debuggables (or <F5>) in a Rust buffer to start.
		end,
	},
	{
		"barreiroleo/ltex_extra.nvim",
		ft = { "tex", "bib", "markdown" },
	},
}

-- vim: ts=2 sts=2 sw=2 et
