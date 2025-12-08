# Neovim Development Environment

Neovim configuration with vim-plug, coc.nvim (LSP/completion), ALE (linting/formatting), and native Lua plugins for Go, Ruby, JavaScript/TypeScript, and Rust development.

## Quick Start

```bash
# Full installation (nvim config + all dependencies)
make install

# Or step by step
make setup      # Install nvim config
make deps       # Install language servers and tools
```

## Repository Structure

```
.
├── README.md
├── Makefile                 # Main entry point (run make help)
├── setup.sh                 # Install nvim/vim configuration
├── install-dependencies.sh  # Install language servers and tools
│
├── nvim/                    # Neovim configuration
│   ├── init.vim             # Main nvim config
│   ├── coc-settings.json    # coc.nvim LSP configuration
│   ├── lua/
│   │   └── plugins/         # Lua plugin configs
│   │       ├── lualine.lua
│   │       ├── gitsigns.lua
│   │       ├── which-key.lua
│   │       ├── indent-blankline.lua
│   │       └── nvim-tree.lua
│   └── ftplugin/
│       ├── go.vim
│       ├── javascript.vim
│       ├── ruby.vim
│       ├── rust.vim
│       ├── typescript.vim
│       └── typescriptreact.vim
│
├── vim/                     # Legacy vim configuration
│   └── vimrc
├── coc-settings.json        # Shared coc.nvim config
└── ftplugin/                # Legacy ftplugin files
```

## Setup Options

```bash
# Neovim (default)
make setup            # Copy files to ~/.config/nvim
make setup-symlink    # Use symlinks (changes reflect immediately)
make setup-minimal    # Skip plugin installation

# Legacy Vim
make setup-vim
make setup-vim-symlink
```

## Dependencies

### Required

| Tool | Purpose | Install |
|------|---------|---------|
| Neovim | Editor | `brew install neovim` |
| Node.js | Required for coc.nvim | `brew install node` or [nvm](https://github.com/nvm-sh/nvm) |
| vim-plug | Plugin manager | Auto-installed by setup.sh |
| fzf | Fuzzy finder | `brew install fzf` |
| ripgrep | Fast grep | `brew install ripgrep` |

### Language-Specific

| Language | LSP | Linter | Formatter |
|----------|-----|--------|-----------|
| Go | gopls | golangci-lint | goimports, gofmt |
| Ruby | solargraph | rubocop | rubocop |
| JS/TS | tsserver | eslint | prettier |
| Rust | rust-analyzer | cargo/clippy | rustfmt |

### Install Dependencies

```bash
# Install all
make deps

# Install specific language tools
make deps-go
make deps-ruby
make deps-node
make deps-rust

# Check status
make status
```

### Manual Installation

```bash
# Go
go install golang.org/x/tools/gopls@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Ruby
gem install solargraph rubocop

# Node.js
npm install -g typescript typescript-language-server eslint prettier

# Rust
rustup component add rust-analyzer clippy rustfmt

# fzf
brew install fzf
$(brew --prefix)/opt/fzf/install

# ripgrep
brew install ripgrep
```

## Plugins

Managed via [vim-plug](https://github.com/junegunn/vim-plug).

```bash
# Install/update from command line
make plugins

# Or from within nvim
:PlugInstall
```

### Core Plugins

| Plugin | Purpose |
|--------|---------|
| neoclide/coc.nvim | LSP client, completion, code actions |
| dense-analysis/ale | Linting, formatting (no LSP) |

### Nvim-Native Lua Plugins

| Plugin | Purpose |
|--------|---------|
| nvim-lualine/lualine.nvim | Status line (replaces vim-airline) |
| folke/which-key.nvim | Keybinding popup |
| lewis6991/gitsigns.nvim | Git diff in sign column (replaces gitgutter) |
| lukas-reineke/indent-blankline.nvim | Indent guides |
| nvim-tree/nvim-tree.lua | File explorer |
| nvim-tree/nvim-web-devicons | File icons |

### Fuzzy Finding

| Plugin | Purpose |
|--------|---------|
| junegunn/fzf + fzf.vim | Fuzzy finding |

### Language Support

| Plugin | Purpose |
|--------|---------|
| fatih/vim-go | Go syntax, commands |
| vim-ruby/vim-ruby | Ruby syntax |
| tpope/vim-rails | Rails support |
| tpope/vim-endwise | Auto-add `end` in Ruby |
| pangloss/vim-javascript | JS syntax |
| leafgarland/typescript-vim | TS syntax |
| maxmellon/vim-jsx-pretty | JSX/TSX syntax |
| rust-lang/rust.vim | Rust syntax |
| iamcco/markdown-preview.nvim | Live markdown preview |

### Utilities

| Plugin | Purpose |
|--------|---------|
| tpope/vim-commentary | Comment toggling (gcc) |
| tpope/vim-surround | Surround text objects |
| tpope/vim-repeat | Make `.` work with plugins |
| tpope/vim-fugitive | Git integration |
| tpope/vim-rhubarb | GitHub integration for fugitive |
| cohama/lexima.vim | Auto-close brackets/quotes |
| edkolev/tmuxline.vim | Tmux status line integration |

### Plugin Commands

```vim
:PlugInstall    " Install plugins
:PlugUpdate     " Update plugins
:PlugClean      " Remove unused plugins
:PlugStatus     " Check plugin status
```

## Key Mappings

Leader: `,`
LocalLeader: `,,`

### Discovering Keys (which-key.nvim)

Press `,` and wait ~500ms to see a popup of all available leader mappings with descriptions.

### General

| Mapping | Action |
|---------|--------|
| `,w` | Save file |
| `,q` | Quit |
| `,<space>` | Clear search highlight |
| `,e` | Open netrw explorer |
| `,E` | Toggle nvim-tree |
| `,ef` | Find file in nvim-tree |
| `,n` / `,p` | Next/previous buffer |
| `,bd` | Delete buffer |
| `Ctrl-h/j/k/l` | Window navigation |
| `Ctrl-d` / `Ctrl-u` | Half-page scroll (centered) |

### fzf (Fuzzy Finding)

| Mapping | Action |
|---------|--------|
| `,f` | Find files |
| `,g` | Grep with ripgrep |
| `,b` | List buffers |
| `,l` | Search lines in buffer |
| `,h` | File history |
| `,*` | Grep word under cursor |
| `,gf` | Git files |
| `,gs` | Git status files |
| `,c` | Commands |
| `,:` | Command history |
| `,/` | Search history |

### coc.nvim (LSP)

| Mapping | Action |
|---------|--------|
| `,gd` | Go to definition |
| `,gt` | Go to type definition |
| `,gi` | Go to implementation |
| `,gr` | Find references |
| `K` | Hover documentation |
| `,rn` | Rename symbol |
| `,ca` | Code actions |
| `,qf` | Quick fix |
| `,cf` | Format code |
| `,re` | Refactor |
| `,cl` | Code lens action |
| `,co` | Show outline |
| `,cs` | Search symbols |
| `[g` / `]g` | Previous/next diagnostic |
| `<Tab>` | Trigger/navigate completion |
| `<CR>` | Confirm completion |
| `<C-Space>` | Trigger completion |

### ALE (Linting)

| Mapping | Action |
|---------|--------|
| `[e` / `]e` | Previous/next lint error |
| `,d` | Show error detail |

### gitsigns.nvim

| Mapping | Action |
|---------|--------|
| `]c` / `[c` | Next/previous hunk |
| `,hp` | Preview hunk |
| `,hb` | Blame line |

### Markdown

| Mapping | Action |
|---------|--------|
| `,mp` | Toggle markdown preview |

### Language-Specific (LocalLeader: `,,`)

| Mapping | Go | Ruby | JS/TS | Rust |
|---------|-----|------|-------|------|
| `,,r` | go run | ruby | node/ts-node | cargo run |
| `,,t` | go test | rspec | npm test | cargo test |
| `,,b` | go build | - | - | cargo build |
| `,,c` | - | - | - | cargo check |

## Language Settings

| Language | Indent | Textwidth |
|----------|--------|-----------|
| Go | tabs (4) | 120 |
| Ruby | 2 spaces | 120 |
| JavaScript | 2 spaces | 100 |
| TypeScript | 2 spaces | 100 |
| Rust | 4 spaces | 100 |

## Troubleshooting

### Check coc.nvim status
```vim
:CocInfo
```

### Check coc.nvim extensions
```vim
:CocList extensions
```

### Restart coc.nvim language server
```vim
:CocRestart
```

### Check ALE linting status
```vim
:ALEInfo
```

### Manually trigger ALE fix
```vim
:ALEFix
```

### Check plugin status
```vim
:PlugStatus
```

### Reinstall plugins
```vim
:PlugClean
:PlugInstall
```

### Install coc.nvim extensions manually
```vim
:CocInstall coc-tsserver coc-go coc-rust-analyzer coc-solargraph
```
