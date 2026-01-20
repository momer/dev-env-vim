#!/bin/bash
#
# Set up Neovim/Vim configuration
# Creates symlinks or copies config to ~/.config/nvim (or ~/.vim for legacy)
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Skip languages (populated via --skip=<lang>)
SKIP_LANGUAGES=""

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

# Check if a language should be skipped
should_skip() {
    local lang="$1"
    [[ " $SKIP_LANGUAGES " == *" $lang "* ]]
}

# Generate init.vim from template, stripping skipped language blocks
generate_init_vim() {
    local template="$SCRIPT_DIR/nvim/init.vim.template"
    local output="$1"

    if [[ ! -f "$template" ]]; then
        error "Template file not found: $template"
        exit 1
    fi

    info "Generating init.vim from template..."

    # Build sed script to remove skipped language blocks
    local sed_script=""
    for lang in go ruby node rust ocaml elixir python; do
        if should_skip "$lang"; then
            info "  Excluding $lang configuration"
            # Delete lines between @BEGIN:lang and @END:lang (inclusive)
            sed_script="${sed_script}/\" @BEGIN:${lang}/,/\" @END:${lang}/d;"
        else
            # Just remove the marker comments
            sed_script="${sed_script}/\" @BEGIN:${lang}/d;/\" @END:${lang}/d;"
        fi
    done

    # Apply sed and write output
    sed "$sed_script" "$template" > "$output"
    info "  Generated: $output"
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

# Create nvim directories
create_nvim_directories() {
    info "Creating nvim directories..."
    mkdir -p ~/.config/nvim/lua/plugins
    mkdir -p ~/.config/nvim/ftplugin
    mkdir -p ~/.local/share/nvim/swap
    mkdir -p ~/.local/share/nvim/backup
    mkdir -p ~/.local/share/nvim/undo
}

# Create vim directories (legacy)
create_vim_directories() {
    info "Creating vim directories..."
    mkdir -p ~/.vim/autoload
    mkdir -p ~/.vim/ftplugin
    mkdir -p ~/.vim/undofiles
    mkdir -p ~/.vim/swapfiles
    mkdir -p ~/.vim/backupfiles
}

# Install vim-plug for nvim
install_vim_plug_nvim() {
    info "Installing vim-plug for nvim..."
    local plug_path="$HOME/.local/share/nvim/site/autoload/plug.vim"
    if [[ -f "$plug_path" ]]; then
        info "vim-plug already installed for nvim."
    else
        curl -fLo "$plug_path" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        info "vim-plug installed for nvim."
    fi
}

# Install vim-plug for vim (legacy)
install_vim_plug_vim() {
    info "Installing vim-plug for vim..."
    if [[ -f ~/.vim/autoload/plug.vim ]]; then
        info "vim-plug already installed for vim."
    else
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        info "vim-plug installed for vim."
    fi
}

# Map ftplugin filenames to language names
ftplugin_to_lang() {
    case "$1" in
        go.vim) echo "go" ;;
        ruby.vim) echo "ruby" ;;
        javascript.vim|typescript.vim|typescriptreact.vim) echo "node" ;;
        rust.vim) echo "rust" ;;
        ocaml.vim) echo "ocaml" ;;
        elixir.vim) echo "elixir" ;;
        *) echo "" ;;
    esac
}

# Install nvim config
install_nvim_config() {
    local use_symlink="$1"

    info "Installing nvim configuration..."

    # init.vim - always generated from template (even with symlink, we need to process it)
    backup_if_exists ~/.config/nvim/init.vim
    generate_init_vim ~/.config/nvim/init.vim

    # coc-settings.json
    backup_if_exists ~/.config/nvim/coc-settings.json
    if [[ "$use_symlink" == "true" ]]; then
        ln -sf "$SCRIPT_DIR/nvim/coc-settings.json" ~/.config/nvim/coc-settings.json
        info "  Linked: coc-settings.json"
    else
        cp "$SCRIPT_DIR/nvim/coc-settings.json" ~/.config/nvim/coc-settings.json
        info "  Copied: coc-settings.json"
    fi

    # Lua configs
    info "Installing lua plugin configs..."
    for f in "$SCRIPT_DIR/nvim/lua/plugins/"*.lua; do
        if [[ -f "$f" ]]; then
            local filename=$(basename "$f")
            if [[ "$use_symlink" == "true" ]]; then
                ln -sf "$f" ~/.config/nvim/lua/plugins/"$filename"
                info "    Linked: $filename"
            else
                cp "$f" ~/.config/nvim/lua/plugins/"$filename"
                info "    Copied: $filename"
            fi
        fi
    done

    # ftplugin files
    info "Installing ftplugin files..."
    for f in "$SCRIPT_DIR/nvim/ftplugin/"*.vim; do
        if [[ -f "$f" ]]; then
            local filename=$(basename "$f")
            local lang=$(ftplugin_to_lang "$filename")
            if [[ -n "$lang" ]] && should_skip "$lang"; then
                info "    Skipped: $filename (language skipped)"
                continue
            fi
            if [[ "$use_symlink" == "true" ]]; then
                ln -sf "$f" ~/.config/nvim/ftplugin/"$filename"
                info "    Linked: $filename"
            else
                cp "$f" ~/.config/nvim/ftplugin/"$filename"
                info "    Copied: $filename"
            fi
        fi
    done
}

# Install vim config (legacy)
install_vim_config() {
    local use_symlink="$1"

    info "Installing vim configuration (legacy)..."

    # vimrc
    backup_if_exists ~/.vimrc
    if [[ "$use_symlink" == "true" ]]; then
        ln -sf "$SCRIPT_DIR/vim/vimrc" ~/.vimrc
        info "  Linked: ~/.vimrc"
    else
        cp "$SCRIPT_DIR/vim/vimrc" ~/.vimrc
        info "  Copied: ~/.vimrc"
    fi

    # coc-settings.json
    backup_if_exists ~/.vim/coc-settings.json
    if [[ "$use_symlink" == "true" ]]; then
        ln -sf "$SCRIPT_DIR/coc-settings.json" ~/.vim/coc-settings.json
        info "  Linked: coc-settings.json"
    else
        cp "$SCRIPT_DIR/coc-settings.json" ~/.vim/coc-settings.json
        info "  Copied: coc-settings.json"
    fi

    # ftplugin files
    info "Installing ftplugin files..."
    for f in "$SCRIPT_DIR/ftplugin/"*.vim; do
        if [[ -f "$f" ]]; then
            local filename=$(basename "$f")
            if [[ "$use_symlink" == "true" ]]; then
                ln -sf "$f" ~/.vim/ftplugin/"$filename"
                info "    Linked: $filename"
            else
                cp "$f" ~/.vim/ftplugin/"$filename"
                info "    Copied: $filename"
            fi
        fi
    done
}

# Install nvim plugins
install_nvim_plugins() {
    info "Installing nvim plugins..."
    nvim --headless +PlugInstall +qall
    info "Plugins installed."
}

# Prompt to add shell aliases for nvim
prompt_shell_aliases() {
    echo ""
    echo "Would you like to add shell aliases (vim -> nvim, vi -> nvim)?"
    echo "  1) ~/.zshrc"
    echo "  2) ~/.bashrc"
    echo "  3) ~/.bash_profile"
    echo "  4) Enter custom path"
    echo "  5) Skip"
    echo ""
    read -p "Select option [1-5]: " choice

    local shell_config=""
    case "$choice" in
        1) shell_config="$HOME/.zshrc" ;;
        2) shell_config="$HOME/.bashrc" ;;
        3) shell_config="$HOME/.bash_profile" ;;
        4)
            read -p "Enter path to shell config: " shell_config
            shell_config="${shell_config/#\~/$HOME}"  # Expand ~
            ;;
        5)
            info "Skipping shell aliases."
            return
            ;;
        *)
            warn "Invalid choice. Skipping shell aliases."
            return
            ;;
    esac

    if [[ ! -f "$shell_config" ]]; then
        warn "File $shell_config does not exist. Creating it."
        touch "$shell_config"
    fi

    # Check if aliases already exist
    if grep -q 'alias vim="nvim"' "$shell_config" 2>/dev/null; then
        info "Aliases already exist in $shell_config"
        return
    fi

    # Add aliases
    echo "" >> "$shell_config"
    echo "# Neovim aliases" >> "$shell_config"
    echo 'alias vim="nvim"' >> "$shell_config"
    echo 'alias vi="nvim"' >> "$shell_config"

    info "Added aliases to $shell_config"
    info "Run 'source $shell_config' or restart your terminal to use them."
}

# Install vim plugins (legacy)
install_vim_plugins() {
    info "Installing vim plugins..."
    vim +PlugInstall +qall
    info "Plugins installed."
}

# Print usage
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --nvim             Install neovim configuration (default)"
    echo "  --vim              Install legacy vim configuration"
    echo "  --symlink          Use symlinks instead of copying files"
    echo "  --no-plugins       Skip plugin installation"
    echo "  --no-prompt        Skip shell alias prompt"
    echo "  --skip=<lang>      Skip language config (go, ruby, node, rust, ocaml, elixir, python)"
    echo "                     Can be specified multiple times"
    echo "  --help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --nvim --skip=ruby --skip=rust"
    echo "  $0 --nvim --symlink --skip=go"
    echo ""
    echo "This script will:"
    echo "  1. Create required directories"
    echo "  2. Install vim-plug plugin manager"
    echo "  3. Generate configuration files (excluding skipped languages)"
    echo "  4. Install plugins via :PlugInstall"
}

# Main
main() {
    local use_symlink=false
    local skip_plugins=false
    local skip_prompt=false
    local target="nvim"  # default to nvim

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --nvim)
                target="nvim"
                shift
                ;;
            --vim)
                target="vim"
                shift
                ;;
            --symlink)
                use_symlink=true
                shift
                ;;
            --no-plugins)
                skip_plugins=true
                shift
                ;;
            --no-prompt)
                skip_prompt=true
                shift
                ;;
            --skip=*)
                local lang="${1#--skip=}"
                SKIP_LANGUAGES="$SKIP_LANGUAGES $lang"
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
    if [[ "$target" == "nvim" ]]; then
        echo "Neovim Configuration Setup"
    else
        echo "Vim Configuration Setup (Legacy)"
    fi
    echo "========================================"
    echo ""

    if [[ "$target" == "nvim" ]]; then
        create_nvim_directories
        install_vim_plug_nvim
        install_nvim_config "$use_symlink"

        if ! $skip_plugins; then
            install_nvim_plugins
        else
            warn "Skipping plugin installation. Run 'nvim +PlugInstall +qall' manually."
        fi

        if ! $skip_prompt; then
            prompt_shell_aliases
        fi
    else
        create_vim_directories
        install_vim_plug_vim
        install_vim_config "$use_symlink"

        if ! $skip_plugins; then
            install_vim_plugins
        else
            warn "Skipping plugin installation. Run 'vim +PlugInstall +qall' manually."
        fi
    fi

    echo ""
    info "Setup complete!"
    echo ""
    echo "Next steps:"
    echo "  1. Run ./install-dependencies.sh to install language servers and tools"
    if [[ "$target" == "nvim" ]]; then
        echo "  2. Open nvim and verify plugins with :PlugStatus"
    else
        echo "  2. Open vim and verify plugins with :PlugStatus"
    fi
    echo "  3. Test language features by opening a .go, .rb, .ts, or .rs file"
}

main "$@"
