#!/bin/bash
#
# Install external dependencies for Vim development environment
# Supports: Go, Ruby, JavaScript/TypeScript, Rust
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if a command exists (includes common tool-specific paths)
check_cmd() {
    command -v "$1" >/dev/null 2>&1 && return 0

    # Check Go bin directory
    local gobin="${GOBIN:-$(go env GOPATH 2>/dev/null)/bin}"
    [[ -x "$gobin/$1" ]] && return 0

    # Check Cargo bin directory
    [[ -x "$HOME/.cargo/bin/$1" ]] && return 0

    # Check rbenv shims
    [[ -x "$HOME/.rbenv/shims/$1" ]] && return 0

    # Check opam bin directory
    local opam_switch
    opam_switch="$(opam var bin 2>/dev/null)" || opam_switch="$HOME/.opam/default/bin"
    [[ -x "$opam_switch/$1" ]] && return 0

    return 1
}

# Install Go tools
install_go_tools() {
    info "Checking Go tools..."

    if ! check_cmd go; then
        warn "Go is not installed. Skipping Go tools."
        return
    fi

    if check_cmd gopls; then
        info "  gopls already installed."
    else
        info "  Installing gopls (Go language server)..."
        go install golang.org/x/tools/gopls@latest
    fi

    if check_cmd golangci-lint; then
        info "  golangci-lint already installed."
    else
        info "  Installing golangci-lint..."
        go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    fi

    info "Go tools ready."
}

# Install Ruby tools
install_ruby_tools() {
    info "Checking Ruby tools..."

    if ! check_cmd gem; then
        warn "Ruby/gem is not installed. Skipping Ruby tools."
        return
    fi

    if check_cmd solargraph; then
        info "  solargraph already installed."
    else
        info "  Installing solargraph (Ruby language server)..."
        gem install solargraph
    fi

    # rubocop is typically installed per-project via Bundler
    if check_cmd rubocop; then
        info "  rubocop already installed."
    else
        info "  Installing rubocop (optional global install)..."
        gem install rubocop
    fi

    info "Ruby tools ready."
}

# Install Node.js tools
install_node_tools() {
    info "Checking Node.js tools..."

    if ! check_cmd npm; then
        warn "npm is not installed. Skipping Node.js tools."
        return
    fi

    if check_cmd tsc; then
        info "  typescript already installed."
    else
        info "  Installing typescript..."
        npm install -g typescript
    fi

    if check_cmd typescript-language-server; then
        info "  typescript-language-server already installed."
    else
        info "  Installing typescript-language-server..."
        npm install -g typescript-language-server
    fi

    if check_cmd eslint; then
        info "  eslint already installed."
    else
        info "  Installing eslint..."
        npm install -g eslint
    fi

    if check_cmd prettier; then
        info "  prettier already installed."
    else
        info "  Installing prettier..."
        npm install -g prettier
    fi

    info "Node.js tools ready."
}

# Install Rust tools
install_rust_tools() {
    info "Checking Rust tools..."

    if ! check_cmd rustup; then
        warn "rustup is not installed. Skipping Rust tools."
        return
    fi

    if check_cmd rust-analyzer; then
        info "  rust-analyzer already installed."
    else
        info "  Installing rust-analyzer..."
        rustup component add rust-analyzer
    fi

    if check_cmd cargo-clippy; then
        info "  clippy already installed."
    else
        info "  Installing clippy..."
        rustup component add clippy
    fi

    if check_cmd rustfmt; then
        info "  rustfmt already installed."
    else
        info "  Installing rustfmt..."
        rustup component add rustfmt
    fi

    info "Rust tools ready."
}

# Install OCaml tools
install_ocaml_tools() {
    info "Checking OCaml tools..."

    if ! check_cmd opam; then
        warn "opam is not installed. Skipping OCaml tools."
        warn "Install opam from: https://opam.ocaml.org/doc/Install.html"
        warn "  brew install opam  # macOS"
        warn "  Then run: opam init"
        return
    fi

    # Ensure opam environment is set up
    eval "$(opam env 2>/dev/null)" || true

    if check_cmd ocamllsp; then
        info "  ocaml-lsp-server already installed."
    else
        info "  Installing ocaml-lsp-server (OCaml language server)..."
        opam install -y ocaml-lsp-server
    fi

    if check_cmd ocamlformat; then
        info "  ocamlformat already installed."
    else
        info "  Installing ocamlformat (code formatter)..."
        opam install -y ocamlformat
    fi

    if check_cmd ocamlmerlin; then
        info "  merlin already installed."
    else
        info "  Installing merlin (IDE support)..."
        opam install -y merlin
    fi

    if check_cmd utop; then
        info "  utop already installed."
    else
        info "  Installing utop (improved REPL)..."
        opam install -y utop
    fi

    if check_cmd dune; then
        info "  dune already installed."
    else
        info "  Installing dune (build system)..."
        opam install -y dune
    fi

    info "OCaml tools ready."
    echo ""
    echo "Note: Make sure to add this to your shell profile:"
    echo '  eval "$(opam env)"'
}

# Install Elixir tools
install_elixir_tools() {
    info "Checking Elixir tools..."

    if ! check_cmd mix; then
        warn "Elixir/mix is not installed. Skipping Elixir tools."
        warn "Install Elixir from: https://elixir-lang.org/install.html"
        warn "  brew install elixir  # macOS"
        return
    fi

    if check_cmd elixir-ls; then
        info "  elixir-ls already installed."
    else
        info "  Installing elixir-ls (Elixir language server)..."
        # elixir-ls is typically installed from source or via package managers
        if check_cmd brew; then
            brew install elixir-ls
        else
            warn "  Homebrew not found. Install elixir-ls manually:"
            warn "    https://github.com/elixir-lsp/elixir-ls#building-and-running"
        fi
    fi

    # credo is typically added to mix.exs per-project
    info "  Note: credo is typically installed per-project in mix.exs"

    info "Elixir tools ready."
    echo ""
    echo "Note: For project-specific credo, add to mix.exs:"
    echo '  {:credo, "~> 1.7", only: [:dev, :test], runtime: false}'
}

# Install neovim
install_nvim() {
    info "Installing neovim..."

    if check_cmd nvim; then
        info "neovim is already installed."
        return
    fi

    if check_cmd brew; then
        brew install nvim
    else
        warn "Homebrew not found. Install neovim manually:"
        warn "  https://github.com/neovim/neovim/wiki/Installing-Neovim"
    fi
}

# Install fzf
install_fzf() {
    info "Installing fzf..."

    if check_cmd fzf; then
        info "fzf is already installed."
        return
    fi

    if check_cmd brew; then
        brew install fzf
        "$(brew --prefix)/opt/fzf/install" --all --no-bash --no-zsh --no-fish
    else
        warn "Homebrew not found. Install fzf manually:"
        warn "  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf"
        warn "  ~/.fzf/install"
    fi
}

# Install ripgrep
install_ripgrep() {
    info "Installing ripgrep..."

    if check_cmd rg; then
        info "ripgrep is already installed."
        return
    fi

    if check_cmd brew; then
        brew install ripgrep
    else
        warn "Homebrew not found. Install ripgrep manually from:"
        warn "  https://github.com/BurntSushi/ripgrep/releases"
    fi
}

# Check if a Nerd Font is installed
check_nerd_font() {
    local font_name="$1"
    # Check in system and user font directories
    if [[ -d "/Library/Fonts" ]]; then
        find /Library/Fonts -iname "*${font_name}*Nerd*" 2>/dev/null | grep -q . && return 0
    fi
    if [[ -d "$HOME/Library/Fonts" ]]; then
        find "$HOME/Library/Fonts" -iname "*${font_name}*Nerd*" 2>/dev/null | grep -q . && return 0
    fi
    # Check via brew cask
    if check_cmd brew; then
        brew list --cask 2>/dev/null | grep -qi "font-.*nerd-font" && return 0
    fi
    return 1
}

# List installed Nerd Fonts
list_installed_nerd_fonts() {
    local fonts=()

    # Check brew casks
    if check_cmd brew; then
        while IFS= read -r font; do
            fonts+=("$font (brew)")
        done < <(brew list --cask 2>/dev/null | grep -i "font-.*nerd-font" || true)
    fi

    # Check font directories
    if [[ -d "$HOME/Library/Fonts" ]]; then
        while IFS= read -r font; do
            [[ -n "$font" ]] && fonts+=("$(basename "$font")")
        done < <(find "$HOME/Library/Fonts" -iname "*Nerd*" -type f 2>/dev/null | head -5 || true)
    fi

    if [[ ${#fonts[@]} -gt 0 ]]; then
        printf '%s\n' "${fonts[@]}" | sort -u | head -5
    fi
}

# Install Nerd Font (interactive prompt)
install_nerd_font() {
    info "Nerd Font Setup"
    echo ""
    echo "Nerd Fonts include icons used by nvim-tree and lualine."
    echo "Without a Nerd Font, icons will display as boxes with question marks."
    echo ""

    # Check for existing Nerd Fonts
    local existing_fonts
    existing_fonts=$(list_installed_nerd_fonts)
    if [[ -n "$existing_fonts" ]]; then
        info "Found installed Nerd Font(s):"
        echo "$existing_fonts" | sed 's/^/  /'
        echo ""
        read -p "Install another font? [y/N]: " install_another
        if [[ ! "$install_another" =~ ^[Yy]$ ]]; then
            info "Skipping font installation."
            echo ""
            echo "Remember to configure your terminal to use the Nerd Font!"
            return
        fi
    fi

    if ! check_cmd brew; then
        warn "Homebrew not found. Install a Nerd Font manually from:"
        warn "  https://www.nerdfonts.com/font-downloads"
        echo ""
        echo "After downloading, install by double-clicking the .ttf/.otf files"
        echo "or copying them to ~/Library/Fonts/"
        return
    fi

    echo ""
    echo "Select a Nerd Font to install:"
    echo "  1) Hack Nerd Font        - Clean, monospace (popular)"
    echo "  2) JetBrains Mono        - Modern, readable (JetBrains IDEs)"
    echo "  3) Fira Code Nerd Font   - Ligatures, popular with devs"
    echo "  4) Meslo LG Nerd Font    - Apple-style, works well in terminals"
    echo "  5) Source Code Pro       - Adobe's coding font"
    echo "  6) Enter custom font name"
    echo "  7) Skip"
    echo ""
    read -p "Select option [1-7]: " choice

    local font_cask=""
    local font_name=""
    case "$choice" in
        1)
            font_cask="font-hack-nerd-font"
            font_name="Hack Nerd Font"
            ;;
        2)
            font_cask="font-jetbrains-mono-nerd-font"
            font_name="JetBrains Mono Nerd Font"
            ;;
        3)
            font_cask="font-fira-code-nerd-font"
            font_name="Fira Code Nerd Font"
            ;;
        4)
            font_cask="font-meslo-lg-nerd-font"
            font_name="Meslo LG Nerd Font"
            ;;
        5)
            font_cask="font-sauce-code-pro-nerd-font"
            font_name="SauceCodePro Nerd Font"
            ;;
        6)
            echo ""
            echo "Enter the Homebrew cask name (e.g., font-ubuntu-nerd-font):"
            echo "Browse available fonts: brew search nerd-font"
            read -p "Font cask name: " font_cask
            font_name="$font_cask"
            ;;
        7)
            info "Skipping font installation."
            return
            ;;
        *)
            warn "Invalid choice. Skipping font installation."
            return
            ;;
    esac

    if [[ -n "$font_cask" ]]; then
        info "Installing $font_name..."
        if brew install --cask "$font_cask"; then
            info "$font_name installed successfully!"
            echo ""
            echo "Next step: Configure your terminal to use '$font_name'"
            echo ""
            echo "Terminal configuration:"
            echo "  iTerm2:       Preferences > Profiles > Text > Font"
            echo "  Terminal.app: Preferences > Profiles > Font > Change"
            echo "  Alacritty:    ~/.config/alacritty/alacritty.yml (font.normal.family)"
            echo "  Kitty:        ~/.config/kitty/kitty.conf (font_family)"
            echo "  VS Code:      Settings > Terminal > Font Family"
            echo ""
        else
            error "Failed to install $font_name"
        fi
    fi
}

# Print status of all tools
check_status() {
    echo ""
    info "Checking tool status..."
    echo ""

    echo "Go tools:"
    check_cmd gopls && echo "  ✓ gopls" || echo "  ✗ gopls"
    check_cmd golangci-lint && echo "  ✓ golangci-lint" || echo "  ✗ golangci-lint"
    echo ""

    echo "Ruby tools:"
    check_cmd solargraph && echo "  ✓ solargraph" || echo "  ✗ solargraph"
    check_cmd rubocop && echo "  ✓ rubocop" || echo "  ✗ rubocop"
    echo ""

    echo "Node.js tools:"
    check_cmd tsc && echo "  ✓ typescript" || echo "  ✗ typescript"
    check_cmd typescript-language-server && echo "  ✓ typescript-language-server" || echo "  ✗ typescript-language-server"
    check_cmd eslint && echo "  ✓ eslint" || echo "  ✗ eslint"
    check_cmd prettier && echo "  ✓ prettier" || echo "  ✗ prettier"
    echo ""

    echo "Rust tools:"
    check_cmd rust-analyzer && echo "  ✓ rust-analyzer" || echo "  ✗ rust-analyzer"
    check_cmd cargo-clippy && echo "  ✓ clippy" || echo "  ✗ clippy"
    check_cmd rustfmt && echo "  ✓ rustfmt" || echo "  ✗ rustfmt"
    echo ""

    echo "OCaml tools:"
    check_cmd ocamllsp && echo "  ✓ ocaml-lsp-server" || echo "  ✗ ocaml-lsp-server"
    check_cmd ocamlformat && echo "  ✓ ocamlformat" || echo "  ✗ ocamlformat"
    check_cmd ocamlmerlin && echo "  ✓ merlin" || echo "  ✗ merlin"
    check_cmd utop && echo "  ✓ utop" || echo "  ✗ utop"
    check_cmd dune && echo "  ✓ dune" || echo "  ✗ dune"
    echo ""

    echo "Elixir tools:"
    check_cmd elixir-ls && echo "  ✓ elixir-ls" || echo "  ✗ elixir-ls"
    check_cmd mix && echo "  ✓ mix (elixir)" || echo "  ✗ mix (elixir)"
    echo ""

    echo "General tools:"
    check_cmd nvim && echo "  ✓ neovim" || echo "  ✗ neovim"
    check_cmd fzf && echo "  ✓ fzf" || echo "  ✗ fzf"
    check_cmd rg && echo "  ✓ ripgrep" || echo "  ✗ ripgrep"
    echo ""

    echo "Nerd Fonts (for icons):"
    local nerd_fonts
    nerd_fonts=$(list_installed_nerd_fonts)
    if [[ -n "$nerd_fonts" ]]; then
        echo "$nerd_fonts" | while read -r font; do
            echo "  ✓ $font"
        done
    else
        echo "  ✗ No Nerd Font found (icons will show as boxes)"
        echo "    Run: ./install-dependencies.sh fonts"
    fi
    echo ""

    echo "coc.nvim requirements:"
    check_cmd node && echo "  ✓ node $(node --version)" || echo "  ✗ node (required for coc.nvim)"
    echo ""
}

# Check Node.js for coc.nvim
check_node_for_coc() {
    if ! check_cmd node; then
        warn "Node.js is required for coc.nvim (LSP client)"
        warn "Install Node.js (v14.14+) from https://nodejs.org or via nvm"
        return 1
    fi

    local node_version=$(node --version | sed 's/v//' | cut -d. -f1)
    if [[ "$node_version" -lt 14 ]]; then
        warn "Node.js v14.14+ is required for coc.nvim. Found: $(node --version)"
        return 1
    fi

    info "Node.js $(node --version) found (required for coc.nvim)"
    return 0
}

# Main
main() {
    echo "========================================"
    echo "Vim Development Environment Dependencies"
    echo "========================================"
    echo ""

    # Check Node.js first (required for coc.nvim)
    check_node_for_coc || warn "Some features may not work without Node.js"
    echo ""

    case "${1:-all}" in
        go)
            install_go_tools
            ;;
        ruby)
            install_ruby_tools
            ;;
        node|js|javascript|typescript)
            install_node_tools
            ;;
        rust)
            install_rust_tools
            ;;
        ocaml)
            install_ocaml_tools
            ;;
        elixir)
            install_elixir_tools
            ;;
        nvim|neovim)
            install_nvim
            ;;
        fzf)
            install_fzf
            ;;
        ripgrep|rg)
            install_ripgrep
            ;;
        fonts|font|nerd-font)
            install_nerd_font
            ;;
        status|check)
            check_status
            ;;
        all)
            install_nvim
            echo ""
            install_go_tools
            echo ""
            install_ruby_tools
            echo ""
            install_node_tools
            echo ""
            install_rust_tools
            echo ""
            install_ocaml_tools
            echo ""
            install_elixir_tools
            echo ""
            install_fzf
            echo ""
            install_ripgrep
            echo ""
            install_nerd_font
            echo ""
            check_status
            ;;
        *)
            echo "Usage: $0 [nvim|go|ruby|node|rust|ocaml|elixir|fzf|ripgrep|fonts|status|all]"
            echo ""
            echo "Options:"
            echo "  nvim     Install neovim"
            echo "  go       Install Go tools (gopls, golangci-lint)"
            echo "  ruby     Install Ruby tools (solargraph, rubocop)"
            echo "  node     Install Node.js tools (typescript, tsserver, eslint, prettier)"
            echo "  rust     Install Rust tools (rust-analyzer, clippy, rustfmt)"
            echo "  ocaml    Install OCaml tools (ocaml-lsp-server, ocamlformat, merlin, utop, dune)"
            echo "  elixir   Install Elixir tools (elixir-ls, credo)"
            echo "  fzf      Install fzf fuzzy finder"
            echo "  ripgrep  Install ripgrep"
            echo "  fonts    Install a Nerd Font (for icons in nvim-tree/lualine)"
            echo "  status   Check installation status of all tools"
            echo "  all      Install all tools (default)"
            exit 1
            ;;
    esac

    info "Done!"
}

main "$@"
