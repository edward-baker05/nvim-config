local M = {}

local function executable(name)
	return vim.fn.executable(name) == 1
end

local function is_macos()
	return vim.fn.has("macunix") == 1
end

local function pdf_engine()
	for _, engine in ipairs({ "xelatex", "pdflatex" }) do
		if executable(engine) then
			return engine
		end
	end
end

local function output_path(filepath)
	local filename = vim.fn.fnamemodify(filepath, ":t:r") .. ".pdf"
	return vim.fs.joinpath(vim.fs.dirname(filepath), filename)
end

local function can_open_app(name)
	if not is_macos() or not executable("open") then
		return false
	end

	local result = vim.system({ "open", "-Ra", name }, { text = true }):wait()
	return result.code == 0
end

local function open_pdf(filepath)
	if is_macos() and executable("open") then
		if can_open_app("Skim") then
			vim.fn.jobstart({ "open", "-a", "Skim", filepath }, { detach = true })
		else
			vim.fn.jobstart({ "open", filepath }, { detach = true })
		end
		return
	end

	if executable("xdg-open") then
		vim.fn.jobstart({ "xdg-open", filepath }, { detach = true })
	elseif executable("open") then
		vim.fn.jobstart({ "open", filepath }, { detach = true })
	else
		vim.notify("Markdown PDF written to " .. filepath, vim.log.levels.INFO)
	end
end

function M.compile_pdf()
	if not executable("pandoc") then
		vim.notify("Markdown PDF compile requires pandoc.", vim.log.levels.WARN)
		return
	end

	local filepath = vim.api.nvim_buf_get_name(0)
	if filepath == "" then
		vim.notify("Save this Markdown buffer before compiling it.", vim.log.levels.WARN)
		return
	end

	if vim.bo.modified then
		vim.cmd.write()
	end

	local pdf = output_path(filepath)
	local command = { "pandoc", filepath, "--from", "markdown", "--output", pdf }
	local engine = pdf_engine()

	if engine then
		vim.list_extend(command, { "--pdf-engine", engine })
	end

	vim.notify("Compiling Markdown PDF...", vim.log.levels.INFO)

	vim.system(command, { text = true }, function(result)
		vim.schedule(function()
			if result.code == 0 then
				vim.notify("Markdown PDF ready: " .. pdf, vim.log.levels.INFO)
				open_pdf(pdf)
				return
			end

			local message = vim.trim(result.stderr)
			if message == "" then
				message = "pandoc exited with code " .. result.code
			end
			vim.notify(message, vim.log.levels.ERROR)
		end)
	end)
end

return M

