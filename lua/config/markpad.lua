local M = {}

local group = vim.api.nvim_create_augroup("config-markpad-preview", { clear = true })
local state = { enabled = false }

local function is_macos()
	return vim.fn.has("macunix") == 1
end

local function required_tools_available()
	return vim.fn.executable("open") == 1 and vim.fn.executable("osascript") == 1
end

local function can_target_markpad()
	if not is_macos() or not required_tools_available() then
		return false
	end

	local result = vim.system({ "open", "-Ra", "Markpad" }, { text = true }):wait()
	return result.code == 0
end

local function open_current_markdown()
	local filepath = vim.api.nvim_buf_get_name(0)
	if filepath == "" or vim.bo.filetype ~= "markdown" then
		return
	end

	local command = [[current_app=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true'); ]]
		.. "open -g -a 'Markpad' "
		.. vim.fn.shellescape(filepath)
		.. [[; sleep 0.2; osascript -e "tell application \"$current_app\" to activate"]]

	vim.fn.jobstart({ "sh", "-c", command }, { detach = true })
end

function M.is_available()
	return can_target_markpad()
end

function M.is_enabled()
	return state.enabled
end

function M.enable()
	if state.enabled then
		open_current_markdown()
		return true
	end

	if not can_target_markpad() then
		vim.notify("Markpad preview requires macOS with the Markpad app installed.", vim.log.levels.WARN)
		return false
	end

	state.enabled = true
	open_current_markdown()

	vim.api.nvim_create_autocmd("BufEnter", {
		group = group,
		pattern = "*.md",
		callback = open_current_markdown,
	})

	vim.notify("Markpad preview: ON", vim.log.levels.INFO)
	return true
end

function M.disable()
	if not state.enabled then
		return false
	end

	state.enabled = false
	vim.api.nvim_clear_autocmds({ group = group })
	vim.notify("Markpad preview: OFF", vim.log.levels.INFO)
	return true
end

function M.toggle()
	if state.enabled then
		M.disable()
	else
		M.enable()
	end
end

return M
