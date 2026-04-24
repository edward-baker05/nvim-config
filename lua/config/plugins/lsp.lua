return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			notify_on_error = true,
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
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
					ensure_installed = {},
				},
			},
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			local lsp = require("config.lsp")
			local capabilities = lsp.capabilities()

			lsp.setup()

			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "pyright" },
			})

			for server_name, config in pairs(lsp.servers(capabilities)) do
				vim.lsp.config(server_name, config)
				vim.lsp.enable(server_name)
			end
		end,
	},
	{
		"barreiroleo/ltex_extra.nvim",
		ft = { "tex", "bib", "markdown" },
	},
	{
		"seblyng/roslyn.nvim",
		ft = "cs",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			local capabilities = require("config.lsp").capabilities()

			require("roslyn").setup({
				config = {
					capabilities = capabilities,
					choose_target = function(targets)
						return vim.iter(targets):find(function(target)
							return target:match("%.sln$") or target:match("%.slnx$")
						end)
					end,
				},
			})
		end,
	},
}

-- vim: ts=2 sts=2 sw=2 et
