local M = {}

local attach_group = vim.api.nvim_create_augroup("config-lsp-attach", { clear = true })
local format_group = vim.api.nvim_create_augroup("config-lsp-format", { clear = true })
local formatting_exclusions = {
	ltex_plus = true,
}

local function format_enabled(bufnr)
	if vim.g.autoformat == nil then
		vim.g.autoformat = true
	end

	return vim.g.autoformat and vim.b[bufnr].autoformat ~= false
end

local function format_filter(client)
	return client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting)
		and not formatting_exclusions[client.name]
end

local function lsp_map(bufnr, lhs, rhs, desc, mode)
	vim.keymap.set(mode or "n", lhs, rhs, {
		buffer = bufnr,
		desc = "LSP: " .. desc,
	})
end

local function setup_user_commands()
	local commands = vim.api.nvim_get_commands({ builtin = false })

	if commands.FormatToggle then
		vim.api.nvim_del_user_command("FormatToggle")
	end

	if commands.Format then
		vim.api.nvim_del_user_command("Format")
	end

	vim.api.nvim_create_user_command("FormatToggle", function()
		vim.g.autoformat = not format_enabled(0)
		vim.notify("Autoformat: " .. (vim.g.autoformat and "ON" or "OFF"))
	end, { desc = "Toggle LSP format-on-save" })

	vim.api.nvim_create_user_command("Format", function()
		vim.lsp.buf.format({
			async = false,
			filter = format_filter,
		})
	end, { desc = "Format the current buffer" })
end

local function setup_diagnostics()
	vim.diagnostic.config({
		severity_sort = true,
		underline = true,
		update_in_insert = false,
		virtual_text = {
			prefix = "●",
			source = "if_many",
		},
		float = {
			border = "rounded",
			source = "if_many",
		},
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "E",
				[vim.diagnostic.severity.WARN] = "W",
				[vim.diagnostic.severity.INFO] = "I",
				[vim.diagnostic.severity.HINT] = "H",
			},
		},
	})
end

local function maybe_enable_inlay_hints(client, bufnr)
	if vim.bo[bufnr].filetype == "markdown" or vim.bo[bufnr].filetype == "tex" then
		return
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
end

local function setup_attach()
	vim.api.nvim_create_autocmd("LspAttach", {
		group = attach_group,
		callback = function(event)
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if not client then
				return
			end

			local fzf = require("fzf-lua")

			lsp_map(event.buf, "gd", fzf.lsp_definitions, "[G]oto [D]efinition")
			lsp_map(event.buf, "gr", fzf.lsp_references, "[G]oto [R]eferences")
			lsp_map(event.buf, "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
			lsp_map(event.buf, "K", vim.lsp.buf.hover, "Hover documentation")
			lsp_map(event.buf, "<leader>D", fzf.lsp_typedefs, "Type [D]efinition")
			lsp_map(event.buf, "<leader>ds", fzf.lsp_document_symbols, "[D]ocument [S]ymbols")
			lsp_map(event.buf, "<leader>ws", fzf.lsp_workspace_symbols, "[W]orkspace [S]ymbols")
			lsp_map(event.buf, "<leader>ca", function()
				fzf.lsp_code_actions({
					winopts = {
						relative = "cursor",
						width = 0.6,
						height = 0.4,
						row = 1,
						preview = { hidden = "hidden" },
					},
					previewer = false,
				})
			end, "[C]ode [A]ction")
			lsp_map(event.buf, "<leader>cf", "<cmd>Format<CR>", "[C]ode [F]ormat")
			lsp_map(event.buf, "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

			maybe_enable_inlay_hints(client, event.buf)

			vim.api.nvim_clear_autocmds({ group = format_group, buffer = event.buf })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = format_group,
				buffer = event.buf,
				callback = function(args)
					if not format_enabled(args.buf) then
						return
					end

					require("conform").format({
						bufnr = args.buf,
						lsp_format = "fallback",
					})
				end,
			})
		end,
	})
end

function M.capabilities()
	return require("blink.cmp").get_lsp_capabilities()
end

function M.setup()
	setup_user_commands()
	setup_diagnostics()
	setup_attach()
end

function M.servers(capabilities)
	local ltex_path = vim.fs.joinpath(vim.fn.stdpath("config"), "ltex")

	return {
		lua_ls = {
			capabilities = capabilities,
			settings = {
				Lua = {
					completion = {
						callSnippet = "Replace",
					},
					hint = {
						enable = true,
					},
				},
			},
		},
		pyright = {
			capabilities = capabilities,
		},
		ltex_plus = {
			capabilities = capabilities,
			filetypes = { "markdown", "tex", "bib" },
			on_attach = function(client, bufnr)
				require("ltex_extra").setup({
					load_langs = { "en-GB" },
					path = ltex_path,
				})

				-- Monkey-patch ltex_extra to avoid "Error catching ltex client" when buffer switches
				local commands = require("ltex_extra.commands-lsp")
				local orig_catch_ltex = commands.catch_ltex
				commands.catch_ltex = function()
					local c = orig_catch_ltex()
					if not c then
						return client
					end
					return c
				end
			end,
			settings = {
				ltex = {
					language = "en-GB",
					checkFrequency = "save",
					enabled = { "markdown", "latex", "tex", "bib" },
				},
			},
		},
	}
end

return M

-- vim: ts=2 sts=2 sw=2 et
