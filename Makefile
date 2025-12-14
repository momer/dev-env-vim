# Neovim/Vim Development Environment Makefile
#
# Usage:
#   make install          - Full setup (nvim config + all dependencies)
#   make setup            - Install nvim config only
#   make deps             - Install all language dependencies
#   make help             - Show all targets

.PHONY: help install setup setup-symlink setup-minimal plugins update deps deps-nvim deps-go deps-ruby deps-node deps-rust deps-ocaml deps-elixir deps-fzf deps-ripgrep deps-fonts status clean
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
	@echo "  make deps                    Install all dependencies"
	@echo "  make deps SKIP=\"ruby go\"     Skip specific languages"
	@echo "  make deps-nvim      Install neovim"
	@echo "  make deps-go        Install Go tools (gopls, golangci-lint)"
	@echo "  make deps-ruby      Install Ruby tools (solargraph, rubocop)"
	@echo "  make deps-node      Install Node.js tools (typescript, eslint, prettier)"
	@echo "  make deps-rust      Install Rust tools (rust-analyzer, clippy, rustfmt)"
	@echo "  make deps-ocaml     Install OCaml tools (ocaml-lsp-server, ocamlformat, merlin)"
	@echo "  make deps-elixir    Install Elixir tools (elixir-ls, credo)"
	@echo "  make deps-fzf       Install fzf fuzzy finder"
	@echo "  make deps-ripgrep   Install ripgrep"
	@echo "  make deps-fonts     Install a Nerd Font (for icons)"
	@echo ""
	@echo "Other targets:"
	@echo "  make status         Check installation status"
	@echo "  make clean          Remove nvim config (keeps backups)"
	@echo "  make clean-vim      Remove vim config (keeps backups)"

# Full installation (nvim)
# Use SKIP to exclude languages: make install SKIP="ruby go"
install: setup
	@$(MAKE) deps SKIP="$(SKIP)"
	@echo ""
	@echo "Installation complete!"
	@echo "Run 'make status' to verify tool installation."

# Build --skip arguments for setup.sh from SKIP variable
SKIP_ARGS := $(foreach lang,$(SKIP),--skip=$(lang))

# Setup nvim configuration (copy)
setup:
	./setup.sh --nvim $(SKIP_ARGS)

# Setup nvim configuration (symlink)
setup-symlink:
	./setup.sh --nvim --symlink $(SKIP_ARGS)

# Setup nvim configuration without plugins
setup-minimal:
	./setup.sh --nvim --no-plugins $(SKIP_ARGS)

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
# Use SKIP to exclude languages: make deps SKIP="ruby go"
deps: deps-nvim deps-fzf deps-ripgrep
ifneq (,$(findstring go,$(SKIP)))
	@echo "Skipping Go tools (SKIP contains 'go')"
else
	@$(MAKE) deps-go
endif
ifneq (,$(findstring ruby,$(SKIP)))
	@echo "Skipping Ruby tools (SKIP contains 'ruby')"
else
	@$(MAKE) deps-ruby
endif
ifneq (,$(findstring node,$(SKIP)))
	@echo "Skipping Node.js tools (SKIP contains 'node')"
else
	@$(MAKE) deps-node
endif
ifneq (,$(findstring rust,$(SKIP)))
	@echo "Skipping Rust tools (SKIP contains 'rust')"
else
	@$(MAKE) deps-rust
endif
ifneq (,$(findstring ocaml,$(SKIP)))
	@echo "Skipping OCaml tools (SKIP contains 'ocaml')"
else
	@$(MAKE) deps-ocaml
endif
ifneq (,$(findstring elixir,$(SKIP)))
	@echo "Skipping Elixir tools (SKIP contains 'elixir')"
else
	@$(MAKE) deps-elixir
endif
ifneq (,$(findstring fonts,$(SKIP)))
	@echo "Skipping Nerd Font (SKIP contains 'fonts')"
else
	@$(MAKE) deps-fonts
endif
	@$(MAKE) status

# Neovim
deps-nvim:
	./install-dependencies.sh nvim

# Language-specific dependencies
deps-go:
	./install-dependencies.sh go

deps-ruby:
	./install-dependencies.sh ruby

deps-node:
	./install-dependencies.sh node

deps-rust:
	./install-dependencies.sh rust

deps-ocaml:
	./install-dependencies.sh ocaml

deps-elixir:
	./install-dependencies.sh elixir

deps-fzf:
	./install-dependencies.sh fzf

deps-ripgrep:
	./install-dependencies.sh ripgrep

deps-fonts:
	./install-dependencies.sh fonts

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
