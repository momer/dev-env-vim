# Neovim Migration Plan

This document outlines the migration from vim to neovim, including nvim-native plugin upgrades.

## Overview

**Current State**: Vim configuration with vim-plug, coc.nvim, ALE, fzf
**Target State**: Neovim configuration with nvim-native plugins where beneficial

## Phase 1: Directory Structure & File Migration

### New Structure

```
.
├── README.md                    # Update with nvim instructions
├── NVIM_MIGRATION_PLAN.md       # This file
├── Makefile                     # Update targets for nvim
├── setup.sh                     # Update for nvim paths
├── install-dependencies.sh      # Mostly unchanged
│
├── vim/                         # Legacy vim config (optional, for backwards compat)
│   └── vimrc
│
├── nvim/
│   ├── init.vim                 # Main nvim config (vimscript)
│   ├── lua/
│   │   └── plugins/             # Lua plugin configs
│   │       ├── lualine.lua
│   │       ├── gitsigns.lua
│   │       ├── which-key.lua
│   │       ├── indent-blankline.lua
│   │       └── nvim-tree.lua
│   ├── coc-settings.json        # coc.nvim config (unchanged)
│   └── ftplugin/                # Filetype configs
│       ├── go.vim
│       ├── javascript.vim
│       ├── ruby.vim
│       ├── rust.vim
│       ├── typescript.vim
│       └── typescriptreact.vim
│
└── ftplugin/                    # Remove (moved to nvim/ftplugin/)
```

### Tasks

- [ ] Create `nvim/` directory structure
- [ ] Copy `vimrc` → `nvim/init.vim`
- [ ] Copy `coc-settings.json` → `nvim/coc-settings.json`
- [ ] Copy `ftplugin/` → `nvim/ftplugin/`
- [ ] Create `nvim/lua/plugins/` directory

## Phase 2: Update init.vim for Neovim

### Remove Vim-Only Settings

These are defaults in neovim or no longer exist:

```vim
" Remove these lines:
set nocompatible          " not needed in nvim
set encoding=utf-8        " default in nvim
set ttyfast               " not needed in nvim
```

### Update Paths

```vim
" Change backup/swap/undo directories
set directory=~/.local/share/nvim/swap//
set backupdir=~/.local/share/nvim/backup//
set undodir=~/.local/share/nvim/undo//
```

### Tasks

- [ ] Remove deprecated vim settings
- [ ] Update directory paths for nvim
- [ ] Test basic functionality

## Phase 3: Plugin Upgrades

### Plugins to Replace

| Current Plugin | Replacement | Reason |
|----------------|-------------|--------|
| vim-airline | lualine.nvim | Faster, better customization, lua-native |
| vim-which-key | folke/which-key.nvim | Better UI, lazy-loading, more features |
| vim-gitgutter | gitsigns.nvim | Async, faster, more features (blame, hunk preview) |
| (none) | indent-blankline.nvim | New - indent guides |
| (none) | nvim-tree.lua | New - file explorer (replaces netrw :Explore) |
| (none) | nvim-web-devicons | New - file icons for nvim-tree, lualine |

### Plugins to Keep (work fine in nvim)

- vim-plug (plugin manager)
- coc.nvim (LSP/completion)
- ALE (linting/formatting)
- fzf + fzf.vim (fuzzy finding)
- vim-go, rust.vim, vim-ruby, etc. (language support)
- tpope plugins (commentary, surround, fugitive, endwise, rails)
- lexima.vim (auto-pairs)

### New Plugins to Add

| Plugin | Purpose |
|--------|---------|
| nvim-lua/plenary.nvim | Required dependency for many lua plugins |
| iamcco/markdown-preview.nvim | Live markdown preview in browser |
| tpope/vim-repeat | Make `.` work with plugin mappings |
| tpope/vim-rhubarb | GitHub integration for fugitive |

### Tasks

- [ ] Add plenary.nvim (dependency)
- [ ] Add nvim-web-devicons
- [ ] Replace vim-airline with lualine.nvim
- [ ] Replace vim-which-key with which-key.nvim
- [ ] Replace vim-gitgutter with gitsigns.nvim
- [ ] Add indent-blankline.nvim
- [ ] Add nvim-tree.lua
- [ ] Add markdown-preview.nvim
- [ ] Add vim-repeat
- [ ] Add vim-rhubarb
- [ ] Remove old plugins from plugin block
- [ ] Create lua config files for each new plugin

## Phase 4: Lua Plugin Configurations

### nvim/lua/plugins/lualine.lua

```lua
require('lualine').setup({
  options = {
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  extensions = {'fugitive', 'nvim-tree'}
})
```

### nvim/lua/plugins/gitsigns.lua

```lua
require('gitsigns').setup({
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end
    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})
    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})
    -- Actions
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
  end
})
```

### nvim/lua/plugins/which-key.lua

```lua
require('which-key').setup({
  plugins = {
    marks = true,
    registers = true,
    spelling = { enabled = false },
  },
  win = {
    border = "rounded",
    padding = { 2, 2, 2, 2 },
  },
})

local wk = require('which-key')
wk.add({
  { "<leader>w", desc = "Save file" },
  { "<leader>q", desc = "Quit" },
  { "<leader><space>", desc = "Clear search highlight" },
  { "<leader>e", desc = "File explorer" },
  { "<leader>n", desc = "Next buffer" },
  { "<leader>p", desc = "Previous buffer" },
  { "<leader>bd", desc = "Delete buffer" },
  -- fzf
  { "<leader>f", desc = "Find files" },
  { "<leader>g", desc = "Grep (ripgrep)" },
  { "<leader>b", desc = "List buffers" },
  { "<leader>l", desc = "Search lines" },
  { "<leader>h", desc = "File history" },
  { "<leader>c", desc = "Commands" },
  { "<leader>*", desc = "Grep word under cursor" },
  { "<leader>:", desc = "Command history" },
  { "<leader>/", desc = "Search history" },
  -- git (fzf)
  { "<leader>gf", desc = "Git files" },
  { "<leader>gs", desc = "Git status files" },
  -- coc.nvim
  { "<leader>gd", desc = "Go to definition" },
  { "<leader>gt", desc = "Go to type definition" },
  { "<leader>gi", desc = "Go to implementation" },
  { "<leader>gr", desc = "Find references" },
  { "<leader>rn", desc = "Rename symbol" },
  { "<leader>ca", desc = "Code actions" },
  { "<leader>qf", desc = "Quick fix" },
  { "<leader>cf", desc = "Format code" },
  { "<leader>re", desc = "Refactor" },
  { "<leader>cl", desc = "Code lens action" },
  { "<leader>co", desc = "Show outline" },
  { "<leader>cs", desc = "Search symbols" },
  -- ALE
  { "<leader>d", desc = "Show lint error detail" },
  -- gitsigns
  { "<leader>hp", desc = "Preview hunk" },
  { "<leader>hb", desc = "Blame line" },
  -- nvim-tree
  { "<leader>E", desc = "Toggle file tree" },
  -- markdown
  { "<leader>mp", desc = "Markdown preview" },
})
```

### nvim/lua/plugins/indent-blankline.lua

```lua
require('ibl').setup({
  indent = {
    char = '│',
  },
  scope = {
    enabled = true,
    show_start = false,
    show_end = false,
  },
})
```

### nvim/lua/plugins/nvim-tree.lua

```lua
require('nvim-tree').setup({
  view = {
    width = 35,
    side = 'left',
  },
  renderer = {
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },
  filters = {
    dotfiles = false,
    custom = { '.git', 'node_modules', '.cache' },
  },
  git = {
    enable = true,
    ignore = false,
  },
  actions = {
    open_file = {
      quit_on_open = false,
      resize_window = true,
    },
  },
})

vim.keymap.set('n', '<leader>E', ':NvimTreeToggle<CR>', { silent = true })
vim.keymap.set('n', '<leader>ef', ':NvimTreeFindFile<CR>', { silent = true })
```

### Tasks

- [ ] Create nvim/lua/plugins/lualine.lua
- [ ] Create nvim/lua/plugins/gitsigns.lua
- [ ] Create nvim/lua/plugins/which-key.lua
- [ ] Create nvim/lua/plugins/indent-blankline.lua
- [ ] Create nvim/lua/plugins/nvim-tree.lua
- [ ] Add lua require statements to init.vim

## Phase 5: Update Plugin Block in init.vim

### New Plugin Block

```vim
call plug#begin('~/.local/share/nvim/plugged')

" Core
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'

" Lua plugin dependencies
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-web-devicons'

" UI (nvim-native)
Plug 'nvim-lualine/lualine.nvim'
Plug 'folke/which-key.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'nvim-tree/nvim-tree.lua'

" Fuzzy Finding
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Ruby
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-endwise'

" JavaScript/TypeScript
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'

" Rust
Plug 'rust-lang/rust.vim'

" Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }

" Utilities
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'cohama/lexima.vim'

" Tmux
Plug 'edkolev/tmuxline.vim'

call plug#end()
```

### Tasks

- [ ] Update plugin block with new plugins
- [ ] Remove vim-airline
- [ ] Remove vim-gitgutter
- [ ] Remove vim-which-key
- [ ] Add lua plugin loading after plug#end()

## Phase 6: Update init.vim - Load Lua Configs

Add after `call plug#end()`:

```vim
" -----------------------------------------------------------------------------
" Load Lua Plugin Configurations
" -----------------------------------------------------------------------------
lua require('plugins.lualine')
lua require('plugins.gitsigns')
lua require('plugins.which-key')
lua require('plugins.indent-blankline')
lua require('plugins.nvim-tree')
```

### Tasks

- [ ] Add lua require block to init.vim
- [ ] Remove vim-which-key configuration section
- [ ] Remove vim-airline configuration section
- [ ] Update keymaps (remove old, ensure new ones work)

## Phase 7: Update setup.sh

### Changes Needed

```bash
# Neovim config directory
NVIM_CONFIG_DIR="$HOME/.config/nvim"
NVIM_DATA_DIR="$HOME/.local/share/nvim"

# Create nvim directories
mkdir -p "$NVIM_CONFIG_DIR"
mkdir -p "$NVIM_CONFIG_DIR/lua/plugins"
mkdir -p "$NVIM_CONFIG_DIR/ftplugin"
mkdir -p "$NVIM_DATA_DIR/swap"
mkdir -p "$NVIM_DATA_DIR/backup"
mkdir -p "$NVIM_DATA_DIR/undo"

# Copy/symlink nvim config
cp nvim/init.vim "$NVIM_CONFIG_DIR/init.vim"
cp nvim/coc-settings.json "$NVIM_CONFIG_DIR/coc-settings.json"
cp -r nvim/lua/* "$NVIM_CONFIG_DIR/lua/"
cp -r nvim/ftplugin/* "$NVIM_CONFIG_DIR/ftplugin/"

# Install vim-plug for nvim
curl -fLo "$NVIM_DATA_DIR/site/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install plugins
nvim --headless +PlugInstall +qall
```

### Tasks

- [ ] Update setup.sh for nvim paths
- [ ] Add nvim-specific directory creation
- [ ] Update plugin installation command
- [ ] Optionally keep vim setup as fallback

## Phase 8: Update Makefile

### New/Updated Targets

```makefile
# Primary targets (nvim)
install: setup deps plugins

setup:
	./setup.sh --nvim

setup-symlink:
	./setup.sh --nvim --symlink

plugins:
	nvim --headless +PlugInstall +qall

update:
	nvim --headless +PlugUpdate +qall

# Legacy vim targets
setup-vim:
	./setup.sh --vim

# ... rest unchanged
```

### Tasks

- [ ] Update Makefile for nvim as default
- [ ] Add legacy vim targets
- [ ] Update plugin commands to use nvim

## Phase 9: Update README.md

### Changes Needed

- Update title/description to mention Neovim
- Update Quick Start section
- Update Repository Structure
- Update Plugin list (new plugins, removed plugins)
- Update Key Mappings (new mappings from nvim plugins)
- Add note about vim legacy support (if keeping)

### Tasks

- [ ] Update README.md for nvim

## Phase 10: Testing & Validation

### Test Checklist

- [ ] Fresh install works (`make install`)
- [ ] Symlink install works (`make setup-symlink`)
- [ ] All plugins load without errors
- [ ] coc.nvim LSP works (Go, Ruby, JS/TS, Rust)
- [ ] ALE linting works
- [ ] fzf fuzzy finding works
- [ ] nvim-tree opens/closes correctly
- [ ] gitsigns shows git diff in sign column
- [ ] which-key popup appears on leader press
- [ ] indent-blankline shows indent guides
- [ ] lualine status bar displays correctly
- [ ] Markdown preview works
- [ ] All keymaps function correctly
- [ ] Filetype-specific settings apply

### Tasks

- [ ] Test on clean environment
- [ ] Fix any issues discovered
- [ ] Update documentation if needed

## Summary

### Files to Create

1. `nvim/init.vim`
2. `nvim/coc-settings.json`
3. `nvim/ftplugin/*.vim` (copy from existing)
4. `nvim/lua/plugins/lualine.lua`
5. `nvim/lua/plugins/gitsigns.lua`
6. `nvim/lua/plugins/which-key.lua`
7. `nvim/lua/plugins/indent-blankline.lua`
8. `nvim/lua/plugins/nvim-tree.lua`

### Files to Update

1. `setup.sh`
2. `Makefile`
3. `README.md`

### Files to Remove/Archive

1. `vimrc` (move to `vim/vimrc` for legacy support, or delete)
2. `ftplugin/` (move contents to `nvim/ftplugin/`)

### Plugins Added

- nvim-lua/plenary.nvim
- nvim-tree/nvim-web-devicons
- nvim-lualine/lualine.nvim
- folke/which-key.nvim
- lewis6991/gitsigns.nvim
- lukas-reineke/indent-blankline.nvim
- nvim-tree/nvim-tree.lua
- iamcco/markdown-preview.nvim
- tpope/vim-repeat
- tpope/vim-rhubarb

### Plugins Removed

- vim-airline/vim-airline (replaced by lualine)
- liuchengxu/vim-which-key (replaced by which-key.nvim)
- airblade/vim-gitgutter (replaced by gitsigns.nvim)
