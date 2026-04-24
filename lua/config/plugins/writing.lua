return {
	{
		"lervag/vimtex",
		ft = { "tex", "plaintex", "bib" },
		init = function()
			vim.g.tex_flavor = "latex"
			vim.g.vimtex_quickfix_mode = 0
			vim.g.vimtex_compiler_latexmk = {
				aux_dir = "aux",
				options = {
					"-pdf",
					"-interaction=nonstopmode",
					"-synctex=1",
				},
			}

			if vim.fn.has("macunix") == 1 and vim.fn.executable("open") == 1 then
				vim.g.vimtex_view_method = "skim"
			end
		end,
	},
	{
		"dhruvasagar/vim-table-mode",
		ft = { "markdown", "text" },
	},
}

-- vim: ts=2 sts=2 sw=2 et
