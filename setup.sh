#!/bin/bash
#
# Set up Vim configuration
# Creates symlinks from this repo to ~/.vim and ~/.vimrc
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Backup existing file/directory
backup_if_exists() {
    local target="$1"
    if [[ -e "$target" || -L "$target" ]]; then
        local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        warn "Backing up $target to $backup"
        mv "$target" "$backup"
    fi
}

# Create required directories
create_directories() {
    info "Creating vim directories..."
    mkdir -p ~/.vim/autoload
    mkdir -p ~/.vim/ftplugin
    mkdir -p ~/.vim/undofiles
    mkdir -p ~/.vim/swapfiles
    mkdir -p ~/.vim/backupfiles
}

# Install vim-plug
install_vim_plug() {
    info "Installing vim-plug..."
    if [[ -f ~/.vim/autoload/plug.vim ]]; then
        info "vim-plug already installed."
    else
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        info "vim-plug installed."
    fi
}

# Install vimrc
install_vimrc() {
    info "Installing vimrc..."
    backup_if_exists ~/.vimrc

    if [[ "$1" == "--symlink" ]]; then
        ln -sf "$SCRIPT_DIR/vimrc" ~/.vimrc
        info "Created symlink: ~/.vimrc -> $SCRIPT_DIR/vimrc"
    else
        cp "$SCRIPT_DIR/vimrc" ~/.vimrc
        info "Copied vimrc to ~/.vimrc"
    fi
}

# Install ftplugin files
install_ftplugin() {
    info "Installing ftplugin files..."

    for f in "$SCRIPT_DIR/ftplugin/"*.vim; do
        if [[ -f "$f" ]]; then
            local filename=$(basename "$f")
            if [[ "$1" == "--symlink" ]]; then
                ln -sf "$f" ~/.vim/ftplugin/"$filename"
                info "  Linked: $filename"
            else
                cp "$f" ~/.vim/ftplugin/"$filename"
                info "  Copied: $filename"
            fi
        fi
    done
}

# Install coc-settings.json for coc.nvim
install_coc_settings() {
    info "Installing coc-settings.json..."
    backup_if_exists ~/.vim/coc-settings.json

    if [[ "$1" == "--symlink" ]]; then
        ln -sf "$SCRIPT_DIR/coc-settings.json" ~/.vim/coc-settings.json
        info "Created symlink: ~/.vim/coc-settings.json -> $SCRIPT_DIR/coc-settings.json"
    else
        cp "$SCRIPT_DIR/coc-settings.json" ~/.vim/coc-settings.json
        info "Copied coc-settings.json to ~/.vim/coc-settings.json"
    fi
}

# Install vim plugins
install_plugins() {
    info "Installing vim plugins..."
    vim +PlugInstall +qall
    info "Plugins installed."
}

# Print usage
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --symlink     Use symlinks instead of copying files"
    echo "  --no-plugins  Skip plugin installation"
    echo "  --help        Show this help message"
    echo ""
    echo "This script will:"
    echo "  1. Create required directories (~/.vim/ftplugin, undofiles, etc.)"
    echo "  2. Install vim-plug plugin manager"
    echo "  3. Install vimrc configuration"
    echo "  4. Install language-specific ftplugin files"
    echo "  5. Install coc-settings.json for coc.nvim"
    echo "  6. Install vim plugins via :PlugInstall"
}

# Main
main() {
    local use_symlink=false
    local skip_plugins=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --symlink)
                use_symlink=true
                shift
                ;;
            --no-plugins)
                skip_plugins=true
                shift
                ;;
            --help|-h)
                usage
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done

    echo "========================================"
    echo "Vim Configuration Setup"
    echo "========================================"
    echo ""

    create_directories

    install_vim_plug

    if $use_symlink; then
        install_vimrc --symlink
        install_ftplugin --symlink
        install_coc_settings --symlink
    else
        install_vimrc
        install_ftplugin
        install_coc_settings
    fi

    if ! $skip_plugins; then
        install_plugins
    else
        warn "Skipping plugin installation. Run 'vim +PlugInstall +qall' manually."
    fi

    echo ""
    info "Setup complete!"
    echo ""
    echo "Next steps:"
    echo "  1. Run ./install-dependencies.sh to install language servers and tools"
    echo "  2. Open vim and verify plugins with :PlugStatus"
    echo "  3. Test language features by opening a .go, .rb, .ts, or .rs file"
}

main "$@"
