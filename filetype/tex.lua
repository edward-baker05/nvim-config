vim.api.nvim_create_autocmd({ "FileType" }, { pattern = "tex" , group = optional_group, command = "TSBufDisable highlight" })
