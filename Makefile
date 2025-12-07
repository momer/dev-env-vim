# Vim Development Environment Makefile
#
# Usage:
#   make install          - Full setup (vim config + all dependencies)
#   make setup            - Install vim config only
#   make deps             - Install all language dependencies
#   make help             - Show all targets

.PHONY: help install setup setup-symlink deps deps-go deps-ruby deps-node deps-rust deps-fzf deps-ripgrep status clean

# Default target
help:
	@echo "Vim Development Environment"
	@echo ""
	@echo "Setup targets:"
	@echo "  make install        Full setup: vim config + all dependencies"
	@echo "  make setup          Install vim config (copy files)"
	@echo "  make setup-symlink  Install vim config (symlink files)"
	@echo "  make setup-minimal  Install vim config without plugins"
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
	@echo "  make plugins        Install/update vim plugins"
	@echo "  make clean          Remove vim config (keeps backups)"

# Full installation
install: setup deps
	@echo ""
	@echo "Installation complete!"
	@echo "Run 'make status' to verify tool installation."

# Setup vim configuration (copy)
setup:
	./setup.sh

# Setup vim configuration (symlink)
setup-symlink:
	./setup.sh --symlink

# Setup vim configuration without plugins
setup-minimal:
	./setup.sh --no-plugins

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

# Install/update vim plugins
plugins:
	vim +PlugInstall +PlugUpdate +qall

# Clean up (remove installed config, keeps backups)
clean:
	@echo "Removing vim configuration..."
	@rm -f ~/.vimrc
	@rm -rf ~/.vim/ftplugin
	@rm -f ~/.vim/coc-settings.json
	@echo "Removed ~/.vimrc, ~/.vim/ftplugin/, ~/.vim/coc-settings.json"
	@echo "Note: ~/.vim/autoload, undofiles, swapfiles, backupfiles preserved"
	@echo "Note: Backup files (*.backup.*) preserved"
