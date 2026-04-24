# Neovim Plugin Audit

This document lists all currently installed plugins in the Neovim configuration, detailing their core functionality, keybinds, and whether they act as a dependency for other plugins. This structured format helps simplify future audits and maintenance.

## Independent Plugins

These plugins provide direct value, workflows, or UI improvements to the editor.

### `saghen/blink.cmp`
- **Core Functionality:** Modern, fast autocompletion engine.
- **Keybinds:** 
  - `<C-Space>`: Show/hide documentation.
  - `<C-y>`: Select and accept completion.
  - `<CR>`: Accept completion.
  - `<C-n>` / `<C-p>`: Next/Previous item.
  - `<C-f>` / `<C-b>`: Scroll documentation.
  - `<Tab>` / `<S-Tab>`: Snippet forward/backward.
  - `<C-l>` / `<C-h>`: Snippet forward/backward.
- **Dependency:** No.

### `windwp/nvim-autopairs`
- **Core Functionality:** Automatically closes brackets, quotes, and parenthesis.
- **Keybinds:** None directly mapped (triggers on typing).
- **Dependency:** No.

### `stevearc/conform.nvim`
- **Core Functionality:** Formatting framework (runs CLI formatters like `stylua`).
- **Keybinds:** 
  - `<leader>cf`: Format current buffer.
  - `:FormatToggle`: Toggle autoformat on save.
- **Dependency:** No.

### `neovim/nvim-lspconfig`
- **Core Functionality:** Base configuration for native Neovim LSP support.
- **Keybinds:** 
  - `gd`: Goto Definition.
  - `gr`: Goto References.
  - `gD`: Goto Declaration.
  - `K`: Hover documentation.
  - `<leader>D`: Type Definition.
  - `<leader>ds`: Document Symbols.
  - `<leader>ws`: Workspace Symbols.
  - `<leader>ca`: Code Action.
  - `<leader>rn`: Rename.
- **Dependency:** No.

### `ibhagwan/fzf-lua`
- **Core Functionality:** Highly performant fuzzy finder replacing Telescope.
- **Keybinds:** 
  - `<leader>sf`: Search files.
  - `<leader>sg`: Search by grep.
  - `<leader>sh`: Search help tags.
  - `<leader>sk`: Search keymaps.
  - `<leader>sw`: Search current word.
  - `<leader>sd`: Search diagnostics.
  - `<leader>sr`: Resume last search.
  - `<leader>s.`: Search old files.
  - `<leader><leader>`: Search buffers.
  - `<leader>/`: Fuzzily search current buffer lines.
  - `<leader>s/`: Live grep in open files.
  - `<leader>sn`: Search Neovim config files.
- **Dependency:** No.

### `nvim-neo-tree/neo-tree.nvim`
- **Core Functionality:** File explorer sidebar.
- **Keybinds:** 
  - `<leader>te`: Toggle explorer sidebar.
  - `<C-e>`: Toggle explorer.
- **Dependency:** No.

### `ThePrimeagen/harpoon`
- **Core Functionality:** Fast file navigation and marks.
- **Keybinds:** 
  - `<leader>a`: Add file to Harpoon.
  - `<leader>A`: Toggle Harpoon menu.
  - `<leader>1-9`: Go to Harpoon file 1-9.
  - `<C-v>`, `<C-x>`, `<C-t>`: Open Harpoon entry in vsplit, split, or tab.
- **Dependency:** No.

### `lewis6991/gitsigns.nvim`
- **Core Functionality:** Git diff decorations and hunk management.
- **Keybinds:** 
  - `]h` / `[h`: Next/Previous hunk.
  - `<leader>hs` / `<leader>hr`: Stage/Reset hunk.
  - `<leader>hS` / `<leader>hR`: Stage/Reset buffer.
  - `<leader>hu`: Undo stage hunk.
  - `<leader>hp`: Preview hunk.
  - `<leader>hb`: Blame line.
- **Dependency:** No.

### `folke/flash.nvim`
- **Core Functionality:** Rapid jumping/navigation via search labels.
- **Keybinds:** 
  - `s` / `S` / `gs` / `gS`: Jump/Treesitter navigation in various modes.
- **Dependency:** No.

### `echasnovski/mini.nvim`
- **Core Functionality:** Collection of minimal plugins (Surround, Statusline used here).
- **Keybinds:** 
  - `gza` (add), `gzd` (delete), `gzf` (find), `gzh` (highlight), `gzr` (replace) - Surround operations.
- **Dependency:** No.

### `folke/which-key.nvim`
- **Core Functionality:** Displays popup with possible key bindings.
- **Keybinds:** None (Triggers on leader key).
- **Dependency:** No.

### `mbbill/undotree`
- **Core Functionality:** Visualizer for Neovim's undo history tree.
- **Keybinds:** 
  - `<leader>u`: Toggle Undotree.
- **Dependency:** No.

### `lervag/vimtex`
- **Core Functionality:** LaTeX compilation, navigation, and editing support.
- **Keybinds:** Relies on default `vimtex` mappings (`<localleader>ll`, etc.).
- **Dependency:** No.

### `nvim-treesitter/nvim-treesitter`
- **Core Functionality:** Advanced syntax highlighting and code parsing.
- **Keybinds:** None directly.
- **Dependency:** No.

### `nvim-treesitter/nvim-treesitter-context`
- **Core Functionality:** Sticky scroll showing function/class context.
- **Keybinds:** None.
- **Dependency:** No.

### `lukas-reineke/indent-blankline.nvim`
- **Core Functionality:** Visual indentation guides.
- **Keybinds:** None.
- **Dependency:** No.

### `folke/todo-comments.nvim`
- **Core Functionality:** Highlight TODO, FIXME, NOTE comments.
- **Keybinds:** None explicitly mapped (integrates with search).
- **Dependency:** No.

### `sainnhe/gruvbox-material`
- **Core Functionality:** Primary colorscheme.
- **Keybinds:** None.
- **Dependency:** No.

### `tpope/vim-sleuth`
- **Core Functionality:** Automatically adjusts `shiftwidth` and `expandtab` based on the file.
- **Keybinds:** None.
- **Dependency:** No.

### `Vimjas/vim-python-pep8-indent`
- **Core Functionality:** PEP8-compliant Python indentation.
- **Keybinds:** None.
- **Dependency:** No.

### `dhruvasagar/vim-table-mode`
- **Core Functionality:** Automatic Markdown/text table creation.
- **Keybinds:** Triggered via `:TableModeToggle`.
- **Dependency:** No.

### `barreiroleo/ltex_extra.nvim`
- **Core Functionality:** Extended LTEX functionality for grammar/spell checking in Markdown and LaTeX.
- **Keybinds:** None.
- **Dependency:** No.

### `seblyng/roslyn.nvim`
- **Core Functionality:** C# Language Server integration.
- **Keybinds:** Handled by `lspconfig`.
- **Dependency:** No.

### `dstein64/vim-startuptime`
- **Core Functionality:** Profiler for Neovim startup time.
- **Keybinds:** Triggered via `:StartupTime`.
- **Dependency:** No.

### `folke/lazydev.nvim`
- **Core Functionality:** Faster Neovim Lua API development setup.
- **Keybinds:** None.
- **Dependency:** No.

---

## Dependencies

These plugins exist primarily to support the independent plugins listed above.

### `williamboman/mason.nvim`
- **Core Functionality:** Package manager for LSPs, formatters, and linters.
- **Dependency For:** `nvim-lspconfig`, `conform.nvim`.

### `williamboman/mason-lspconfig.nvim`
- **Core Functionality:** Bridges Mason with `lspconfig`.
- **Dependency For:** `nvim-lspconfig`.

### `WhoIsSethDaniel/mason-tool-installer.nvim`
- **Core Functionality:** Ensures formatters/LSPs are auto-installed.
- **Dependency For:** `nvim-lspconfig`.

### `j-hui/fidget.nvim`
- **Core Functionality:** UI for LSP progress loading.
- **Dependency For:** `nvim-lspconfig`.

### `L3MON4D3/LuaSnip` & `rafamadriz/friendly-snippets`
- **Core Functionality:** Snippet engine and preconfigured snippets.
- **Dependency For:** `blink.cmp`.

### `nvim-lua/plenary.nvim`
- **Core Functionality:** Utility library for Lua.
- **Dependency For:** `harpoon`, `neo-tree.nvim`, `todo-comments.nvim`, `nvim-lsp-file-operations`.

### `MunifTanjim/nui.nvim`
- **Core Functionality:** UI component library.
- **Dependency For:** `neo-tree.nvim`.

### `nvim-tree/nvim-web-devicons`
- **Core Functionality:** Adds filetype icons to UI elements.
- **Dependency For:** `neo-tree.nvim`, `fzf-lua`, `mini.nvim`.

### `antosha417/nvim-lsp-file-operations`
- **Core Functionality:** Renames LSP references when renaming files.
- **Dependency For:** `neo-tree.nvim`.

### `nvim-treesitter/nvim-treesitter-textobjects`
- **Core Functionality:** Provides text objects based on Treesitter AST.
- **Dependency For:** Extends `nvim-treesitter`.