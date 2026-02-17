-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


-- [[ Setting options ]]
-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Set tab sizes
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Disable line wrapping
vim.o.wrap = true
vim.o.linebreak = true
vim.o.list = false

-- Set spellcheck settings
vim.opt.spell = true
vim.opt.spelllang = { "en_gb" }
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python" }, -- Add file types where you want spellcheck disabled
  callback = function()
    vim.opt_local.spell = false
  end,
})

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- IMPORTANT: You might need to set up keymaps for mini.completion
-- Example keymaps (add these outside the mini.nvim config block,
-- typically in your general keymap setup file or section):
vim.keymap.set('i', '<Tab>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-n>' -- Select next item
  elseif require('mini.completion').can_complete_as_is() then
    return require('mini.completion').trigger_completion(false) -- Trigger completion
  else
    return '<Tab>' -- Insert literal tab
  end
end, { expr = true, noremap = true, silent = true })
 vim.keymap.set('i', '<S-Tab>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-p>' -- Select previous item
  else
    return '<S-Tab>' -- Fallback (might not be needed)
  end
end, { expr = true, noremap = true, silent = true })
 vim.keymap.set('i', '<CR>', function()
  if vim.fn.pumvisible() == 1 then
    -- If you want completion item confirmation to insert a newline,
    -- use `"<C-y><CR>"` or `require('mini.completion').confirm_completion() .. "<CR>"`
    -- If you want confirmation to just confirm without adding a newline:
    return vim.fn['mini#completion#confirm']() -- Confirm selection
    -- Or using Lua function:
    -- return require('mini.completion').confirm_completion()
  else
    -- If pum is not visible, execute default <CR> (insert newline)
    -- The `feedkeys` approach ensures other mappings for <CR> can still work
    return vim.api.nvim_replace_termcodes('<CR>', true, false, true)
  end
end, { expr = true, noremap = true, silent = true })
 vim.keymap.set('i', '<Esc>', function()
  if vim.fn.pumvisible() == 1 then
    -- If popup menu is visible, close it
     return vim.fn['mini#completion#close_popup']()
     -- Or using Lua function:
     -- return require('mini.completion').close_popup()
  else
    -- Otherwise, do normal Esc behavior
    return vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
  end
end, { expr = true, noremap = true, silent = true })

-- Spellcheck
vim.api.nvim_set_keymap('i', '<C-l>', '<c-g>u<Esc>[s1z=`]a<c-g>u', { noremap = true, silent = true })

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Move by visual line
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

vim.keymap.set('n', '<C-e>', '<cmd>Ex<CR>')
vim.keymap.set('n', ';', '<ESC>:')

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})


-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  'tpope/vim-sleuth',
  
  { 'glacambre/firenvim', build = ":call firenvim#install(0)" },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

--[[   -- Here is a more advanced example where we pass configuration ]]
  -- options to `gitsigns.nvim`. This is equivalent to the following lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- NOTE: Plugins can also be configured to run lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').add {
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      }
    end,
  },
  {
    'mrcjkb/haskell-tools.nvim',
    version = '^4', -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',

        build = 'make',

        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons' }
    },
    config = function()
      -- [[ Configure Telescope ]]
      require('telescope').setup {
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable telescope extensions, if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      -- 1. Setup Mason first
      require('mason').setup()
      
      -- 2. Ensure tools are installed
      require('mason-tool-installer').setup {
        ensure_installed = { 'pyright', 'stylua' }
      }

      -- 3. Define Keymaps (Runs when LSP attaches)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        end,
      })

      -- 4. Setup Servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup {
              capabilities = capabilities,
            }
          end,
          -- Explicit override for Lua to fix annoying warning
          ['lua_ls'] = function()
            require('lspconfig').lua_ls.setup {
              capabilities = capabilities,
              settings = {
                Lua = { completion = { callSnippet = 'Replace' } },
              },
            }
          end,
        },
      }
    end,
  },

  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = 'aux',
        options = {
          '-pdf',
          '-interaction=nonstopmode',
          '-synctex=1',
        }
      }
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_quickfix_mode = 0
      vim.g.tex_conceal = "abdmg"
      vim.opt.conceallevel = 1
    end
  },

  {
    'SirVer/ultisnips',
    init = function()
      vim.g.UltiSnipsSnippetDirectories = {"~/.config/nvim/UltiSnips"}
      vim.g.UltiSnipsExpandTrigger = '<tab>'
      vim.g.UltiSnipsJumpForwardTrigger = '<tab>'
      vim.g.UltiSnipsJumpBackwardTrigger = '<s-tab>'
    end,
  },

  {
    'honza/vim-snippets'
  },

  {
    --'shaunsingh/nord.nvim',
    --name = 'nord',
    --lazy = false,
    --priority = 1000,
    --config = function()
      --vim.cmd.colorscheme 'nord'
    --end,
  },

  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_contrast_dark = 'soft'
      vim.cmd.colorscheme('gruvbox-material')
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    lazy = false, -- Make sure mini.nvim loads early if completions are desired quickly
    config = function()
      -- Enable core mini modules
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()

      -- Enable mini.completion with default settings
      require('mini.completion').setup()

      -- Setup mini.statusline
      local statusline = require 'mini.statusline'
      statusline.setup {
        -- Set use_icons to true if you have a nerd font and want icons
        use_icons = vim.g.have_nerd_font,
        -- Or force icons regardless of nerd font detection:
        -- use_icons = true,
      }

      -- Customize statusline section (example unchanged from your original)
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- IMPORTANT: You might need to set up keymaps for mini.completion
      -- Example keymaps (add these outside the mini.nvim config block,
      -- typically in your general keymap setup file or section):
      -- vim.keymap.set('i', '<Tab>', function()
      --   if vim.fn.pumvisible() == 1 then
      --     return '<C-n>' -- Select next item
      --   elseif require('mini.completion').can_complete_as_is() then
      --     return require('mini.completion').trigger_completion(false) -- Trigger completion
      --   else
      --     return '<Tab>' -- Insert literal tab
      --   end
      -- end, { expr = true, noremap = true, silent = true })

      -- vim.keymap.set('i', '<S-Tab>', function()
      --   if vim.fn.pumvisible() == 1 then
      --     return '<C-p>' -- Select previous item
      --   else
      --     return '<S-Tab>' -- Fallback (might not be needed)
      --   end
      -- end, { expr = true, noremap = true, silent = true })

      -- vim.keymap.set('i', '<CR>', function()
      --   if vim.fn.pumvisible() == 1 then
      --     -- If you want completion item confirmation to insert a newline,
      --     -- use `"<C-y><CR>"` or `require('mini.completion').confirm_completion() .. "<CR>"`
      --     -- If you want confirmation to just confirm without adding a newline:
      --     return vim.fn['mini#completion#confirm']() -- Confirm selection
      --     -- Or using Lua function:
      --     -- return require('mini.completion').confirm_completion()
      --   else
      --     -- If pum is not visible, execute default <CR> (insert newline)
      --     -- The `feedkeys` approach ensures other mappings for <CR> can still work
      --     return vim.api.nvim_replace_termcodes('<CR>', true, false, true)
      --   end
      -- end, { expr = true, noremap = true, silent = true })

      -- vim.keymap.set('i', '<Esc>', function()
      --   if vim.fn.pumvisible() == 1 then
      --     -- If popup menu is visible, close it
      --      return vim.fn['mini#completion#close_popup']()
      --      -- Or using Lua function:
      --      -- return require('mini.completion').close_popup()
      --   else
      --     -- Otherwise, do normal Esc behavior
      --     return vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
      --   end
      -- end, { expr = true, noremap = true, silent = true })

    end,
  },

  { -- Measure startup time by calling nvim --startuptime or :StartupTime}
    'dstein64/vim-startuptime'
  },

  { -- Python indentation
    'Vimjas/vim-python-pep8-indent'
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'python', 'rust', 'haskell' },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = {
          enable = true,
          disable = { "tex" },
        },
        indent = { enable = true },
      }
    end,
  },
  { import = 'custom.plugins' },
}

vim.api.nvim_create_autocmd({ 'VimEnter', 'BufEnter', 'FileType' }, {
  desc = 'Disable TreeSitter highlighting for specific filetypes',
  group = vim.api.nvim_create_augroup('treesitter-highlight-disable', { clear = true }),
  pattern = { 'tex' }, 
  callback = function()
    vim.cmd "TSBufDisable highlight"
  end,
})


-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
