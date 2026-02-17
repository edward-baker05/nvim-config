# Neovim Keybinds & Features Reference

> **Quick Tip:** Press `<leader>` (spacebar) and wait to see all available commands via which-key!

**Leader Key:** `<space>`

---

## 🚀 **Essential Daily Keybinds**

### **File Navigation** (Start Here!)
| Keybind | Action | Why Use This |
|---------|--------|--------------|
| `<leader>sf` | Find files | Fastest way to open any file - fuzzy search |
| `<leader>sg` | Live grep (search all files) | Find text across entire project |
| `<leader>sw` | Search word under cursor | Find all uses of current word |
| `<leader><leader>` | Switch buffers | Quickly jump between open files |
| `<leader>/` | Search in current buffer | Fuzzy find within current file |
| `<leader>s.` | Recent files | Reopen recently used files |
| `<C-e>` | File explorer (netrw) | Traditional file browser |

### **Harpoon - Lightning Fast Navigation**
| Keybind | Action | Workflow |
|---------|--------|----------|
| `<leader>a` | Mark/add current file | Bookmark your most-used files |
| `<leader>1` to `<leader>5` | Jump to marked file 1-5 | Instant switching between key files |
| `<leader>A` | Harpoon quick menu | View/manage/reorder marked files |
| `<leader>r1` to `<leader>r5` | Remove mark 1-5 | Clean up your marks |

**Harpoon Workflow:** Mark your main files (e.g., 1=main.py, 2=test.py, 3=config.py), then use `<leader>1-5` to instantly jump between them. Game-changer for working with 3-5 core files!

---

## 💻 **LSP - Language Server Features** (Now Working!)

### **Navigation**
| Keybind | Action | Use When |
|---------|--------|----------|
| `gd` | Go to definition | Jump to where function/class/variable is defined |
| `gr` | Find references | See everywhere this symbol is used |
| `gD` | Go to declaration | Jump to declaration (vs implementation) |
| `<leader>D` | Type definition | Jump to type definition |
| `<C-o>` | Jump back | Return after jumping (built-in Vim) |
| `<C-i>` | Jump forward | Go forward in jump list |

### **Code Intelligence**
| Keybind | Action | Use When |
|---------|--------|----------|
| `K` | Hover documentation | Show docs/signature for symbol under cursor |
| `<leader>ca` | Code actions | Quick fixes, organize imports, refactoring |
| `<leader>rn` | Rename symbol | Safely rename variable/function everywhere |
| `<leader>ds` | Document symbols | Outline/table of contents for current file |
| `<leader>ws` | Workspace symbols | Search symbols across entire project |

### **Diagnostics (Errors/Warnings)**
| Keybind | Action | Use When |
|---------|--------|----------|
| `[d` | Previous diagnostic | Jump to previous error/warning |
| `]d` | Next diagnostic | Jump to next error/warning |
| `<leader>e` | Show diagnostic | Floating window with full error details |
| `<leader>q` | Diagnostic quickfix list | List all errors in quickfix window |
| `<leader>sd` | Search diagnostics (Telescope) | Fuzzy search all errors across files |

### **Formatting**
| Keybind | Action | Notes |
|---------|--------|-------|
| *Automatic on save* | Format buffer | Runs whenever you save (`:w`) |
| `:KickstartFormatToggle` | Toggle autoformat | Turn formatting on/off |

---

## ✏️ **Text Editing Superpowers**

### **Commenting** (Comment.nvim)
| Keybind | Action | Example |
|---------|--------|---------|
| `gcc` | Toggle comment line | Comment/uncomment current line |
| `gc` + motion | Comment motion | `gcap` = comment paragraph, `gc3j` = comment 3 lines down |
| `gc` (visual mode) | Comment selection | Select lines and `gc` to comment |
| `gbc` | Block comment line | Use block comment style (e.g., `/* */`) |

### **Surround Operations** (mini.surround)
| Keybind | Action | Example |
|---------|--------|---------|
| `sa` + motion + char | Add surround | `saiw"` = surround word with quotes |
| `sd` + char | Delete surround | `sd"` = remove surrounding quotes |
| `sr` + old + new | Replace surround | `sr"'` = change double quotes to single |
| `sf` + char | Find surround | `sf"` = jump to next " |

**Examples:**
- `saiw"` - Surround inner word with "
- `sa$)` - Surround to end of line with ()
- `sd{` - Delete surrounding {}
- `sr)]` - Replace () with []

### **Enhanced Text Objects** (mini.ai)
Use with any operator (`d`, `c`, `v`, `y`, etc.):

| Text Object | Inside | Around | Example |
|-------------|--------|--------|---------|
| `q` (quotes) | `iq` | `aq` | `ciq` = change inside quotes |
| `b` (brackets) | `ib` | `ab` | `dab` = delete around brackets (any type) |
| `(`, `)` | `i(` | `a(` | `vi(` = select inside parentheses |
| `[`, `]` | `i[` | `a[` | `da[` = delete around brackets |
| `{`, `}` | `i{` | `a{` | `ci{` = change inside braces |
| `<`, `>` | `i<` | `a<` | `di<` = delete inside angle brackets |
| `f` (function) | `if` | `af` | `vaf` = select entire function |
| `a` (argument) | `ia` | `aa` | `cia` = change argument in function call |

**Pro Tip:** The `a` (argument) text object is amazing for function calls:
- `cia` - Change current argument
- `daa` - Delete current argument (including comma)
- `via` - Select current argument

---

## 🔍 **Telescope - Advanced Search**

### **File & Buffer Search**
| Keybind | Action | Use Case |
|---------|--------|----------|
| `<leader>sf` | Find files | Open any file in project |
| `<leader>sg` | Live grep | Search text across all files |
| `<leader>sw` | Grep current word | Find word under cursor everywhere |
| `<leader>s/` | Grep in open files | Search only in currently open buffers |
| `<leader><leader>` | Buffer list | Switch between open files |
| `<leader>/` | Current buffer fuzzy find | Search within current file |

### **Help & Config**
| Keybind | Action | Use Case |
|---------|--------|----------|
| `<leader>sh` | Search help | Search Vim/Neovim help docs |
| `<leader>sk` | Search keymaps | Find all your keybindings |
| `<leader>sn` | Search Neovim config | Quick access to config files |
| `<leader>ss` | Select Telescope | Browse available Telescope pickers |
| `<leader>sr` | Resume last search | Reopen last Telescope search |

### **Inside Telescope** (While picker is open)
| Keybind | Action |
|---------|--------|
| `<C-n>` / `<C-p>` | Next/previous item |
| `<C-q>` | Send to quickfix list |
| `<Tab>` | Mark item (multi-select) |
| `<C-u>` / `<C-d>` | Scroll preview up/down |
| `<Esc>` | Close picker |

---

## 📝 **LaTeX with VimTeX**

### **Compilation & Viewing**
| Keybind | Action |
|---------|--------|
| `\ll` | Start/stop compilation |
| `\lv` | View PDF in Skim |
| `\lc` | Clean auxiliary files |
| `\le` | View errors |
| `\lk` | Stop compilation |

### **Your Custom Snippets** (Type + Tab)
| Trigger | Expands To | Use Case |
|---------|-----------|----------|
| `bp` | Boilerplate document | Start new LaTeX file |
| `beg` | `\begin{} \end{}` | Environments |
| `mk` | `$$` | Inline math with smart spacing |
| `dm` | `\[ \]` | Display math |
| `today` | Current date | Insert date |
| `lec` | `\lecture{}{}{}` | Lecture template |

---

## 🎯 **Completion & Snippets**

### **nvim-cmp (In Insert Mode)**
| Keybind | Action |
|---------|--------|
| `<Tab>` | Select next item OR expand/jump snippet |
| `<S-Tab>` | Select previous item OR jump back in snippet |
| `<CR>` | Confirm selection |
| `<C-Space>` | Manually trigger completion |
| `<C-n>` / `<C-p>` | Navigate items (alternative) |
| `<C-y>` | Accept completion |
| `<C-e>` | Close completion menu |

### **Snippet Navigation**
| Keybind | Action |
|---------|--------|
| `<Tab>` | Jump to next placeholder (when in snippet) |
| `<S-Tab>` | Jump to previous placeholder |
| `<C-l>` | Alternative forward jump |
| `<C-h>` | Alternative backward jump |

---

## 🛠️ **Useful Built-in Vim Keybinds**

### **Movement Enhancements** (Already configured)
| Keybind | Action | Note |
|---------|--------|------|
| `j` / `k` | Move by visual line | Works with wrapped lines |
| `;` | Enter command mode | Alternative to `:` |
| `<C-e>` | File explorer | Opens netrw |

### **Classic Vim Power Moves** (You might not know!)
| Keybind | Action | Example Use |
|---------|--------|-------------|
| `*` / `#` | Search word forward/back | Quick word search |
| `.` | Repeat last change | Super useful! |
| `%` | Jump to matching bracket | Navigate code blocks |
| `ci"` | Change inside quotes | Edit quoted text |
| `dit` | Delete inside tag | Delete HTML/XML tag contents |
| `>` / `<` | Indent/dedent | `>ap` indent paragraph |
| `zz` | Center cursor line | Better view of code |
| `zt` / `zb` | Top/bottom cursor line | Adjust view |
| `<C-o>` / `<C-i>` | Jump backward/forward | Navigate jump history |

### **Window Management**
| Keybind | Action |
|---------|--------|
| `<C-w>v` | Vertical split |
| `<C-w>s` | Horizontal split |
| `<C-w>h/j/k/l` | Navigate between splits |
| `<C-w>=` | Equalize split sizes |
| `<C-w>_` | Maximize height |
| `<C-w>|` | Maximize width |
| `<C-w>q` | Close current split |

### **Marks & Jumps**
| Keybind | Action | Use Case |
|---------|--------|----------|
| `ma` | Set mark 'a' | Remember this position |
| `'a` | Jump to mark 'a' | Return to marked position |
| `''` | Jump to last position | Go back to previous spot |
| `:marks` | List all marks | See all your marks |

---

## 🎨 **Visual Mode Tricks**

### **Selection**
| Keybind | Action |
|---------|--------|
| `v` | Character-wise visual |
| `V` | Line-wise visual |
| `<C-v>` | Block-wise visual (columns!) |
| `gv` | Re-select last selection |
| `o` | Toggle cursor to other end of selection |

### **In Visual Mode**
| Keybind | Action |
|---------|--------|
| `gc` | Comment selection |
| `sa"` | Surround with quotes |
| `>` / `<` | Indent/dedent |
| `J` | Join lines |
| `u` / `U` | Lowercase/uppercase |
| `:norm @a` | Apply macro to each line |

---

## 🔧 **Utility Commands**

### **Useful Ex Commands**
| Command | Action |
|---------|--------|
| `:w` | Save file |
| `:q` | Quit |
| `:wq` or `:x` | Save and quit |
| `:e <file>` | Edit file (but use `<leader>sf` instead!) |
| `:bn` / `:bp` | Next/previous buffer |
| `:bd` | Close buffer |
| `:ls` | List buffers (but use `<leader><leader>` instead!) |
| `:Mason` | Open Mason package manager |
| `:Lazy` | Open Lazy plugin manager |
| `:checkhealth` | Check Neovim health |
| `:LspInfo` | Show LSP status |
| `:StartupTime` | Profile startup time |

### **Diagnostics & LSP**
| Command | Action |
|---------|--------|
| `:KickstartFormatToggle` | Toggle autoformat on save |
| `:LspRestart` | Restart LSP server |
| `:Mason` | Install/manage LSP servers |

---

## 💡 **Powerful Workflows to Try**

### **1. Quick Refactoring Workflow**
1. Place cursor on variable/function name
2. Press `<leader>rn` to rename
3. Type new name
4. Hit Enter - changes everywhere!

### **2. "Find and Replace in Files" Workflow**
1. `<leader>sg` - search for text
2. `<C-q>` - send results to quickfix
3. `:cdo s/old/new/g | update` - replace in all files

### **3. Multi-File Editing**
1. `<leader>sg` to find files/text
2. `<Tab>` to select multiple results
3. `<C-q>` to send to quickfix
4. `:cfdo %s/old/new/g | w` - edit all at once

### **4. Code Navigation Workflow**
1. `<leader>sf` to open file
2. `gd` to jump to definition
3. `<C-o>` to jump back
4. `K` to read documentation
5. `gr` to see all uses

### **5. Harpoon File Juggling**
1. Open your 3-5 main files
2. In each, press `<leader>a` to mark
3. Use `<leader>1-5` to instantly switch
4. Never use file browser again!

### **6. LaTeX Writing Workflow**
1. Open .tex file
2. `\ll` to start continuous compilation
3. `\lv` to open PDF viewer
4. Write with auto-recompile and live preview
5. Use `mk<Tab>` for inline math, `beg<Tab>` for environments

---

## 🚀 **Features You Could Add** (Not Installed Yet)

### **Highly Recommended**
- **nvim-tree** or **neo-tree** - Better file explorer than netrw
- **gitsigns** hunks operations - Stage/undo hunks visually (you have gitsigns but may not know the features!)
- **trouble.nvim** - Better diagnostic/quickfix list
- **vim-fugitive** - Git integration (stage, commit, diff, blame)
- **undotree** - Visual undo history tree
- **flash.nvim** or **hop.nvim** - Jump to any word on screen with 2 keystrokes

### **Nice to Have**
- **nvim-dap** - Debug adapter protocol (actual debugger!)
- **toggleterm** - Better terminal integration
- **nvim-spectre** - Find and replace across project (with preview)
- **aerial.nvim** - Code outline sidebar
- **zen-mode** - Distraction-free writing

---

## 📚 **Learning Resources**

### **Discover More**
- `:help` - The built-in help is excellent!
- `:Telescope help_tags` or `<leader>sh` - Search help docs
- `:Telescope keymaps` or `<leader>sk` - See ALL your keybinds
- Press `<leader>` and wait - which-key shows available commands
- `:checkhealth` - Verify everything is working

### **Practice These First**
1. **File navigation:** Use `<leader>sf` instead of `:e`
2. **Code navigation:** Use `gd` and `gr` constantly
3. **Refactoring:** Use `<leader>rn` to rename
4. **Harpoon:** Mark 3 files and practice jumping
5. **Surround:** Practice `saiw"` and `sr"'`

---

## ⚡ **Quick Reference Card**

**Most Important Keybinds:**
```
<leader>sf   - Find files
<leader>sg   - Search in files
gd           - Go to definition
<leader>rn   - Rename
<leader>a    - Mark file (Harpoon)
<leader>1-5  - Jump to marked file
gcc          - Comment line
K            - Show docs
<leader>ca   - Code actions
[d / ]d      - Next/prev error
```

**Remember:** Press `<leader>` and wait to see all options!

---

*Last updated: After your config cleanup. Everything listed here is currently installed and working!*
