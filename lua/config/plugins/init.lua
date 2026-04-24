local specs = {}

for _, module in ipairs({
	"completion",
	"editing",
	"lsp",
	"navigation",
	"ui",
	"writing",
}) do
	vim.list_extend(specs, require("config.plugins." .. module))
end

return specs

-- vim: ts=2 sts=2 sw=2 et
