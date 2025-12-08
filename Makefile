# Neovim/Vim Development Environment Makefile
#
# Usage:
#   make install          - Full setup (nvim config + all dependencies)
#   make setup            - Install nvim config only
#   make deps             - Install all language dependencies
#   make help             - Show all targets

.PHONY: help install setup setup-symlink setup-minimal plugins update deps deps-go deps-ruby deps-node deps-rust deps-fzf deps-ripgrep status clean
.PHONY: setup-vim setup-vim-symlink plugins-vim

# Default target
help:
	@echo "Neovim/Vim Development Environment"
	@echo ""
	@echo "Neovim targets (default):"
	@echo "  make install        Full setup: nvim config + all dependencies"
	@echo "  make setup          Install nvim config (copy files)"
	@echo "  make setup-symlink  Install nvim config (symlink files)"
	@echo "  make setup-minimal  Install nvim config without plugins"
	@echo "  make plugins        Install/update nvim plugins"
	@echo "  make update         Update nvim plugins"
	@echo ""
	@echo "Legacy Vim targets:"
	@echo "  make setup-vim          Install vim config (copy files)"
	@echo "  make setup-vim-symlink  Install vim config (symlink files)"
	@echo "  make plugins-vim        Install/update vim plugins"
	@echo ""
	@echo "Dependency targets:"
	@echo "  make deps           Install all language dependencies"
	@echo "  make deps-go        Install Go tools (gopls, golangci-lint)"
	@echo "  make deps-ruby      Install Ruby tools (solargraph, rubocop)"
	@echo "  make deps-node      Install Node.js tools (typescript, eslint, prettier)"
	@echo "  make deps-rust      Install Rust tools (rust-analyzer, clippy, rustfmt)"
	@echo "  make deps-fzf       Install fzf fuzzy finder"
	@echo "  make deps-ripgrep   Install ripgrep"
	@echo ""
	@echo "Other targets:"
	@echo "  make status         Check installation status"
	@echo "  make clean          Remove nvim config (keeps backups)"
	@echo "  make clean-vim      Remove vim config (keeps backups)"

# Full installation (nvim)
install: setup deps
	@echo ""
	@echo "Installation complete!"
	@echo "Run 'make status' to verify tool installation."

# Setup nvim configuration (copy)
setup:
	./setup.sh --nvim

# Setup nvim configuration (symlink)
setup-symlink:
	./setup.sh --nvim --symlink

# Setup nvim configuration without plugins
setup-minimal:
	./setup.sh --nvim --no-plugins

# Install/update nvim plugins
plugins:
	nvim --headless +PlugInstall +PlugUpdate +qall

# Update nvim plugins
update:
	nvim --headless +PlugUpdate +qall

# Legacy vim targets
setup-vim:
	./setup.sh --vim

setup-vim-symlink:
	./setup.sh --vim --symlink

plugins-vim:
	vim +PlugInstall +PlugUpdate +qall

# Install all dependencies
deps:
	./install-dependencies.sh all

# Language-specific dependencies
deps-go:
	./install-dependencies.sh go

deps-ruby:
	./install-dependencies.sh ruby

deps-node:
	./install-dependencies.sh node

deps-rust:
	./install-dependencies.sh rust

deps-fzf:
	./install-dependencies.sh fzf

deps-ripgrep:
	./install-dependencies.sh ripgrep

# Check status
status:
	./install-dependencies.sh status

# Clean up nvim (remove installed config, keeps backups)
clean:
	@echo "Removing nvim configuration..."
	@[ -f ~/.config/nvim/init.vim ] && rm -- ~/.config/nvim/init.vim || true
	@[ -f ~/.config/nvim/coc-settings.json ] && rm -- ~/.config/nvim/coc-settings.json || true
	@[ -d ~/.config/nvim/lua/plugins ] && rm -r -- ~/.config/nvim/lua/plugins || true
	@[ -d ~/.config/nvim/ftplugin ] && rm -r -- ~/.config/nvim/ftplugin || true
	@echo "Removed nvim config files"
	@echo "Note: ~/.local/share/nvim (plugins, undo, swap, backup) preserved"
	@echo "Note: Backup files (*.backup.*) preserved"

# Clean up vim (legacy)
clean-vim:
	@echo "Removing vim configuration..."
	@[ -f ~/.vimrc ] && rm -- ~/.vimrc || true
	@[ -d ~/.vim/ftplugin ] && rm -r -- ~/.vim/ftplugin || true
	@[ -f ~/.vim/coc-settings.json ] && rm -- ~/.vim/coc-settings.json || true
	@echo "Removed ~/.vimrc, ~/.vim/ftplugin/, ~/.vim/coc-settings.json"
	@echo "Note: ~/.vim/autoload, undofiles, swapfiles, backupfiles preserved"
	@echo "Note: Backup files (*.backup.*) preserved"
