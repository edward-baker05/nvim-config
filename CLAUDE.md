# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration based on Kickstart.nvim, using lazy.nvim as the plugin manager. The config is structured around a monolithic `init.lua` with additional plugin specifications in `lua/custom/plugins/`.

**User Reference:** See `KEYBINDS.md` for a comprehensive guide to all keybindings and features. The user wants to discover and use more of the powerful features available.

## Configuration Architecture

### Plugin Management
- **Plugin manager**: lazy.nvim (auto-bootstrapped in init.lua:170-177)
- **Plugin definitions**: Main specs in init.lua:179-547, additional specs imported from `lua/custom/plugins/`
- **Lock file**: `lazy-lock.json` pins plugin versions

### Key Architectural Decisions

**Completion System**:
- `nvim-cmp` - Modern completion engine with LSP, path, and snippet sources
- Configured in `lua/custom/plugins/autocompletion.lua`
- Tab/S-Tab for completion navigation and snippet jumping
- Ctrl+Space to manually trigger completion

**Snippet Engine**:
- `LuaSnip` - Modern Lua-based snippet engine
- Custom snippets in `luasnippets/tex.snippets` (LaTeX-specific)
- Pre-made snippets from `friendly-snippets`
- Tab expands/jumps forward, S-Tab jumps backward (when completion not visible)
- Alternative navigation: Ctrl+l (forward), Ctrl+h (backward)

**Statusline**:
- `mini.statusline` - Lightweight statusline from mini.nvim
- Configured in init.lua with custom location format

**File Browser**:
- `neo-tree` - Modern file explorer sidebar (installed alongside netrw)
- Configured in init.lua with preview mode enabled
- Toggle with `<leader>te`
- Netrw still available via `<C-e>` for quick browsing
- Dependencies: nvim-lsp-file-operations (LSP-aware file ops), nvim-window-picker

### Language-Specific Configurations

**LaTeX** (heavily customized):
- VimTeX with Skim viewer integration (init.lua)
- TreeSitter highlighting explicitly disabled for `.tex` files (init.lua, filetype/tex.lua)
- Auxiliary files compiled to `aux/` directory
- Custom LuaSnip snippets in `luasnippets/tex.lua` (bp, beg, today, mk, dm, lec)
- Concealment enabled (conceallevel=1)

**Haskell**:
- Uses `haskell-tools.nvim` v4 (full language server + REPL integration)

**Python**:
- Pyright LSP installed via Mason
- PEP8 indentation plugin

### File Structure Patterns

```
init.lua                          # Monolithic config
├── Options                       # Vim options, spellcheck (en_gb)
├── Keymaps                       # Global keymaps, leader = <space>
├── Autocommands                  # Highlight on yank, TreeSitter disable for tex
└── Plugins                       # lazy.nvim setup

lua/custom/plugins/               # Modular plugin specs
├── autocompletion.lua            # nvim-cmp + LuaSnip + sources
├── harpoon.lua                   # File navigation (harpoon2)
├── autopairs.lua                 # Auto-pairing brackets
├── tablemode.lua                 # Markdown table support
└── plugins.lua                   # Placeholder for additional plugins

luasnippets/                      # Custom LuaSnip snippets
└── tex.lua                       # LaTeX snippets

filetype/                         # Filetype-specific overrides
└── tex.lua                       # Disable TreeSitter for LaTeX

after/syntax/                     # Syntax highlighting customizations
└── markdown.vim                  # Markdown color overrides
```

## Common Operations

### Plugin Management
```bash
# Check plugin status, update, sync
nvim +Lazy

# Update specific plugin
nvim +"Lazy update <plugin-name>"

# Profile startup time
nvim --startuptime startup.log
# Or inside Neovim:
:StartupTime
```

### LSP & Mason
```bash
# Open Mason installer UI
:Mason

# Install LSP server manually
:MasonInstall <server-name>

# Check LSP server status
:LspInfo

# Format toggle
:KickstartFormatToggle
```

### Neo-tree (File Browser)
```bash
# Toggle sidebar
<leader>te

# Inside neo-tree sidebar:
a          # Create new file
A          # Create new directory
d          # Delete file/folder
r          # Rename file/folder
c/x/p      # Copy/cut/paste
P          # Toggle preview
?          # Show all keybinds
```

### Testing Changes
After editing config files:
```vim
:source ~/.config/nvim/init.lua
" Or restart Neovim
```

## Key Custom Keybindings

### Harpoon (File Navigation)
- `<leader>a` - Add file to harpoon
- `<leader>A` - Toggle harpoon quick menu
- `<leader>1-5` - Jump to harpoon file 1-5
- `<leader>r1-r5` - Remove file from harpoon slot

### Completion (nvim-cmp) & Snippets (LuaSnip)
- `<Tab>` - Navigate completion forward OR expand/jump snippet
- `<S-Tab>` - Navigate completion backward OR jump snippet backward
- `<CR>` - Confirm completion selection
- `<C-n>/<C-p>` - Navigate completion items
- `<C-Space>` - Manually trigger completion
- `<C-l>/<C-h>` - Snippet navigation (forward/backward)
- `<C-y>` - Accept completion

### File Browsers
- `<C-e>` - Open netrw file explorer (quick browsing)
- `<leader>te` - Toggle neo-tree sidebar (persistent file tree)
- Inside neo-tree: `P` to toggle preview, `?` for help

### Other
- `;` - Enter command mode (alias for `:`)
- `j`/`k` - Move by visual lines (not physical lines)

## Important Constraints

1. **TreeSitter disabled for LaTeX**: VimTeX handles syntax, TreeSitter conflicts with it
2. **Indentation**: Handled automatically by vim-sleuth (no manual tab settings)
3. **Tab behavior**: Smart Tab - completes if menu visible, expands/jumps snippets otherwise
4. **Mason tools**: Only pyright and stylua are auto-installed
5. **Leader key**: `<space>` for both leader and localleader
6. **Custom snippets**: LaTeX snippets in `luasnippets/tex.lua` (LuaSnip format, not UltiSnips)
7. **Autoformatting**: Integrated into LSP config, toggle with `:KickstartFormatToggle`

## Editing Best Practices

When modifying this config:
- Main settings go in `init.lua` (options, core keymaps, plugin specs)
- New plugin specs can be added to `lua/custom/plugins/` as separate files
- Filetype-specific tweaks go in `filetype/<filetype>.lua`
- Syntax customizations go in `after/syntax/<filetype>.vim`
- Custom snippets go in `luasnippets/<filetype>.lua` (LuaSnip format)

When adding plugins:
- Always specify if plugin should be `lazy = false` (load immediately)
- Add to `ensure_installed` arrays for TreeSitter/Mason if language support needed
- Consider which-key group mappings for new keybindings

When adding snippets:
- Create `luasnippets/<filetype>.lua` files using LuaSnip syntax
- See `luasnippets/tex.lua` for examples
- Snippets are auto-loaded from the luasnippets directory
