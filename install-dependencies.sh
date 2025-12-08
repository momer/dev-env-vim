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

    return 1
}

# Install Go tools
install_go_tools() {
    info "Installing Go tools..."

    if ! check_cmd go; then
        warn "Go is not installed. Skipping Go tools."
        return
    fi

    info "  Installing gopls (Go language server)..."
    go install golang.org/x/tools/gopls@latest

    info "  Installing golangci-lint..."
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

    info "Go tools installed successfully."
}

# Install Ruby tools
install_ruby_tools() {
    info "Installing Ruby tools..."

    if ! check_cmd gem; then
        warn "Ruby/gem is not installed. Skipping Ruby tools."
        return
    fi

    info "  Installing solargraph (Ruby language server)..."
    gem install solargraph

    # rubocop is typically installed per-project via Bundler
    if ! check_cmd rubocop; then
        info "  Installing rubocop (optional global install)..."
        gem install rubocop
    else
        info "  rubocop already installed."
    fi

    info "Ruby tools installed successfully."
}

# Install Node.js tools
install_node_tools() {
    info "Installing Node.js tools..."

    if ! check_cmd npm; then
        warn "npm is not installed. Skipping Node.js tools."
        return
    fi

    info "  Installing typescript..."
    npm install -g typescript

    info "  Installing typescript-language-server..."
    npm install -g typescript-language-server

    info "  Installing eslint..."
    npm install -g eslint

    info "  Installing prettier..."
    npm install -g prettier

    info "Node.js tools installed successfully."
}

# Install Rust tools
install_rust_tools() {
    info "Installing Rust tools..."

    if ! check_cmd rustup; then
        warn "rustup is not installed. Skipping Rust tools."
        return
    fi

    info "  Installing rust-analyzer..."
    rustup component add rust-analyzer

    info "  Installing clippy..."
    rustup component add clippy

    info "  Installing rustfmt..."
    rustup component add rustfmt

    info "Rust tools installed successfully."
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

    echo "General tools:"
    check_cmd nvim && echo "  ✓ neovim" || echo "  ✗ neovim"
    check_cmd fzf && echo "  ✓ fzf" || echo "  ✗ fzf"
    check_cmd rg && echo "  ✓ ripgrep" || echo "  ✗ ripgrep"
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
        nvim|neovim)
            install_nvim
            ;;
        fzf)
            install_fzf
            ;;
        ripgrep|rg)
            install_ripgrep
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
            install_fzf
            echo ""
            install_ripgrep
            echo ""
            check_status
            ;;
        *)
            echo "Usage: $0 [nvim|go|ruby|node|rust|fzf|ripgrep|status|all]"
            echo ""
            echo "Options:"
            echo "  nvim     Install neovim"
            echo "  go       Install Go tools (gopls, golangci-lint)"
            echo "  ruby     Install Ruby tools (solargraph, rubocop)"
            echo "  node     Install Node.js tools (typescript, tsserver, eslint, prettier)"
            echo "  rust     Install Rust tools (rust-analyzer, clippy, rustfmt)"
            echo "  fzf      Install fzf fuzzy finder"
            echo "  ripgrep  Install ripgrep"
            echo "  status   Check installation status of all tools"
            echo "  all      Install all tools (default)"
            exit 1
            ;;
    esac

    info "Done!"
}

main "$@"
