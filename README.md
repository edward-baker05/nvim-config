# Neovim Config

Neovim `0.12` configuration built around `lazy.nvim`, with coding and writing treated as first-class workflows through filetype-local behavior instead of global leakage.

## Structure

- `init.lua`: bootstrap, loader, built-in plugin disables, leaders.
- `lua/config/init.lua`: ordered config entrypoint.
- `lua/config/options.lua`: global editor defaults only.
- `lua/config/keymaps.lua`: global keymaps and toggles.
- `lua/config/autocmds.lua`: global autocommands.
- `lua/config/lazy.lua`: `lazy.nvim` bootstrap and performance settings.
- `lua/config/lsp.lua`: shared LSP, diagnostics, format, and attach behavior.
- `lua/config/treesitter.lua`: Treesitter parser and textobject policy.
- `lua/config/markpad.lua`: optional macOS Markpad integration.
- `lua/config/plugins/*.lua`: plugin specs grouped by concern.
- `ftplugin/*.lua`: filetype-local writing behavior.
- `luasnippets/tex.lua`: local LaTeX snippets.
- `ltex/`: persisted LTEX dictionaries and ignored findings.
- `after/syntax/markdown.vim`: Markdown heading highlight overrides.

## Design Rules

- Global defaults stay minimal and predictable.
- Writing behavior is scoped to writing filetypes.
- Plugin specs should lazy-load on real triggers.
- Built-in Neovim `0.12` APIs are preferred over legacy compatibility patterns.
- Optional platform-specific features must degrade cleanly.

## Workflow Notes

- Wrapped-line movement is smart-scoped: `j` and `k` use display lines only when wrapping is active and no count is supplied.
- `;` opens the command-line by design. This intentionally gives up Vim’s built-in repeat-find motion.
- `:FormatToggle` toggles LSP format-on-save globally.
- `<leader>tf` toggles autoformat.
- Markdown, text, git commit, and TeX buffers enable wrap, linebreak, and spell locally.
- Markdown buffers can toggle Markpad preview with `<leader>tp` when running on macOS with Markpad installed.

## Plugin Inventory

See [AUDIT.md](/Users/edwardbaker/.config/nvim/AUDIT.md) for the full audit report, plugin inventory, replacement recommendations, and maintenance notes.
