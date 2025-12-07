# Vim Development Environment

Vim configuration with vim-plug, ALE (LSP/linting/formatting), and fzf for Go, Ruby, JavaScript/TypeScript, and Rust development.

## Quick Start

```bash
# Install vim config
./setup.sh

# Install language servers and tools
./install-dependencies.sh
```

## Repository Structure

```
.
├── README.md
├── setup.sh                 # Install vim configuration
├── install-dependencies.sh  # Install language servers and tools
├── vimrc                    # Main vim configuration
└── ftplugin/
    ├── go.vim               # Go-specific settings
    ├── javascript.vim       # JavaScript settings
    ├── ruby.vim             # Ruby settings
    ├── rust.vim             # Rust settings
    ├── typescript.vim       # TypeScript settings
    └── typescriptreact.vim  # TSX settings
```

## Setup Options

```bash
# Copy files to ~/.vim and ~/.vimrc
./setup.sh

# Use symlinks instead (changes to repo reflect immediately)
./setup.sh --symlink

# Skip plugin installation
./setup.sh --no-plugins
```

## Dependencies

### Required

| Tool | Purpose | Install |
|------|---------|---------|
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
./install-dependencies.sh

# Install specific language tools
./install-dependencies.sh go
./install-dependencies.sh ruby
./install-dependencies.sh node
./install-dependencies.sh rust

# Check status
./install-dependencies.sh status
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
# Install from command line
vim +PlugInstall +qall

# Or from within vim
:PlugInstall
```

| Plugin | Purpose |
|--------|---------|
| dense-analysis/ale | LSP, linting, formatting |
| vim-airline/vim-airline | Status line |
| edkolev/tmuxline.vim | Tmux status line integration |
| junegunn/fzf + fzf.vim | Fuzzy finding |
| fatih/vim-go | Go syntax, commands |
| vim-ruby/vim-ruby | Ruby syntax |
| tpope/vim-rails | Rails support |
| tpope/vim-endwise | Auto-add `end` in Ruby |
| pangloss/vim-javascript | JS syntax |
| leafgarland/typescript-vim | TS syntax |
| maxmellon/vim-jsx-pretty | JSX/TSX syntax |
| rust-lang/rust.vim | Rust syntax |
| tpope/vim-commentary | Comment toggling (gcc) |
| tpope/vim-surround | Surround text objects |
| tpope/vim-fugitive | Git integration |
| airblade/vim-gitgutter | Git diff in sign column |
| cohama/lexima.vim | Auto-close brackets/quotes |

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

### General

| Mapping | Action |
|---------|--------|
| `,w` | Save file |
| `,q` | Quit |
| `,<space>` | Clear search highlight |
| `,e` | Open file explorer |
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

### ALE (LSP)

| Mapping | Action |
|---------|--------|
| `,gd` | Go to definition |
| `,gt` | Go to type definition |
| `,gr` | Find references |
| `,K` | Hover info |
| `,rn` | Rename symbol |
| `,d` | Show error detail |
| `[e` / `]e` | Previous/next error |

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

### Check ALE status
```vim
:ALEInfo
```

### Check if LSP is running
```vim
:ALELspDetail
```

### Manually trigger format
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
