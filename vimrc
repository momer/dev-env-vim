" =============================================================================
" Vim Configuration - vim-plug + coc.nvim + ALE
" =============================================================================

" -----------------------------------------------------------------------------
" Plugin Block
" -----------------------------------------------------------------------------
call plug#begin('~/.vim/plugged')

" Core
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'
Plug 'vim-airline/vim-airline'
Plug 'edkolev/tmuxline.vim'

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

" Utilities
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'cohama/lexima.vim'
Plug 'liuchengxu/vim-which-key'

call plug#end()

" -----------------------------------------------------------------------------
" General Settings
" -----------------------------------------------------------------------------

" Encoding
set encoding=utf-8
set fileencoding=utf-8

" Enable syntax and filetype detection
syntax enable
filetype plugin indent on

" Display
set number                    " Show line numbers
set relativenumber            " Relative line numbers
set cursorline                " Highlight current line
set showmatch                 " Show matching brackets
set wrap                      " Wrap long lines
set linebreak                 " Break at word boundaries
set scrolloff=8               " Keep 8 lines visible above/below cursor
set sidescrolloff=8           " Keep 8 columns visible left/right
set signcolumn=yes            " Always show sign column (for ALE/git)

" Colorscheme
set background=dark
colorscheme monokai

" Search
set hlsearch                  " Highlight search results
set incsearch                 " Incremental search
set ignorecase                " Case-insensitive search
set smartcase                 " Case-sensitive if uppercase present

" Splits
set splitbelow                " Open horizontal splits below
set splitright                " Open vertical splits to the right

" Buffers
set hidden                    " Allow hidden buffers

" Backup/Swap
set directory=~/.vim/swapfiles//
set backupdir=~/.vim/backupfiles//

" Undo persistence
set undofile
set undodir=~/.vim/undofiles//

" Command line
set wildmenu                  " Enhanced command line completion
set wildmode=list:longest,full
set showcmd                   " Show partial commands
set laststatus=2              " Always show statusline

" Performance
set lazyredraw                " Don't redraw during macros
set updatetime=300            " Faster updates (for git gutter, etc.)

" Mouse
set mouse=a                   " Enable mouse support

" Clipboard
set clipboard+=unnamed        " Use system clipboard

" -----------------------------------------------------------------------------
" Default Indentation
" -----------------------------------------------------------------------------
set tabstop=4                 " Tab = 4 spaces
set shiftwidth=4              " Indent = 4 spaces
set softtabstop=4             " Backspace deletes 4 spaces
set expandtab                 " Use spaces, not tabs
set smartindent               " Smart auto-indenting
set autoindent                " Copy indent from current line

" -----------------------------------------------------------------------------
" Key Mappings
" -----------------------------------------------------------------------------

" Leader key
let mapleader = ","
let maplocalleader = ",,"

" Clear search highlight
nnoremap <Leader><space> :nohlsearch<CR>

" Quick save/quit
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>

" Buffer navigation
nnoremap <Leader>n :bn<CR>
nnoremap <Leader>p :bp<CR>
nnoremap <Leader>bd :bd<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" File explorer
nnoremap <Leader>e :Explore<CR>

" Center screen on navigation
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzz
nnoremap N Nzz

" Move lines in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Keep visual selection when indenting
vnoremap < <gv
vnoremap > >gv

" -----------------------------------------------------------------------------
" ALE Configuration (linting only - LSP handled by coc.nvim)
" -----------------------------------------------------------------------------

" Disable ALE LSP features (use coc.nvim instead)
let g:ale_disable_lsp = 1
let g:ale_completion_enabled = 0

" Fix files on save
let g:ale_fix_on_save = 1

" Lint settings
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_delay = 200

" Navigate between ALE diagnostics (linting errors)
nmap <silent> [e <Plug>(ale_previous_wrap)
nmap <silent> ]e <Plug>(ale_next_wrap)
nmap <Leader>d <Plug>(ale_detail)

" Airline integration
let g:airline#extensions#ale#enabled = 1

" Linters (no LSP servers - coc.nvim handles those)
let g:ale_linters = {
\   'go': ['golangci-lint'],
\   'ruby': ['rubocop'],
\   'javascript': ['eslint'],
\   'typescript': ['eslint'],
\   'typescriptreact': ['eslint'],
\   'javascriptreact': ['eslint'],
\   'rust': ['cargo'],
\}

" Fixers
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'go': ['goimports', 'gofmt'],
\   'ruby': ['rubocop'],
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\   'typescriptreact': ['prettier', 'eslint'],
\   'javascriptreact': ['prettier', 'eslint'],
\   'json': ['prettier'],
\   'css': ['prettier'],
\   'html': ['prettier'],
\   'markdown': ['prettier'],
\   'yaml': ['prettier'],
\   'rust': ['rustfmt'],
\}

" Language-specific ALE settings
let g:ale_go_golangci_lint_package = 1
let g:ale_ruby_rubocop_executable = 'bundle'
let g:ale_javascript_eslint_use_global = 0
let g:ale_javascript_prettier_use_global = 0
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')

" -----------------------------------------------------------------------------
" vim-go Configuration
" -----------------------------------------------------------------------------

" Disable vim-go LSP (use ALE instead)
let g:go_gopls_enabled = 0
let g:go_code_completion_enabled = 0
let g:go_def_mapping_enabled = 0
let g:go_diagnostics_enabled = 0
let g:go_echo_go_info = 0

" Keep syntax highlighting
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1

" Disable vim-go formatting (use ALE)
let g:go_fmt_autosave = 0
let g:go_imports_autosave = 0
let g:go_mod_fmt_autosave = 0

" -----------------------------------------------------------------------------
" rust.vim Configuration
" -----------------------------------------------------------------------------

" Disable rust.vim formatting (use ALE)
let g:rustfmt_autosave = 0
let g:rust_clip_command = 'pbcopy'

" -----------------------------------------------------------------------------
" fzf Configuration
" -----------------------------------------------------------------------------

" Use ripgrep
if executable('rg')
    let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
endif

" Layout
let g:fzf_layout = { 'down': '40%' }
let g:fzf_preview_window = ['right:50%', 'ctrl-/']

" Key mappings
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>/ :Rg<CR>
nnoremap <Leader>l :Lines<CR>
nnoremap <Leader>h :History<CR>
nnoremap <Leader>: :History:<CR>
nnoremap <Leader>? :History/<CR>
nnoremap <Leader>c :Commands<CR>
nnoremap <Leader>* :Rg <C-R><C-W><CR>
nnoremap <Leader>gf :GFiles<CR>
nnoremap <Leader>gs :GFiles?<CR>

" Custom Rg with preview
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

" -----------------------------------------------------------------------------
" Airline Configuration
" -----------------------------------------------------------------------------

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1

" -----------------------------------------------------------------------------
" coc.nvim Configuration
" -----------------------------------------------------------------------------

" coc extensions to install
let g:coc_global_extensions = [
\   'coc-json',
\   'coc-tsserver',
\   'coc-eslint',
\   'coc-prettier',
\   'coc-go',
\   'coc-solargraph',
\   'coc-rust-analyzer',
\]

" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
\   coc#pum#visible() ? coc#pum#next(1) :
\   CheckBackspace() ? "\<Tab>" :
\   coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
\   : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> <Leader>gd <Plug>(coc-definition)
nmap <silent> <Leader>gt <Plug>(coc-type-definition)
nmap <silent> <Leader>gi <Plug>(coc-implementation)
nmap <silent> <Leader>gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <Leader>rn <Plug>(coc-rename)

" Formatting
nmap <Leader>cf <Plug>(coc-format)
xmap <Leader>cf <Plug>(coc-format-selected)

" Code actions
nmap <Leader>ca <Plug>(coc-codeaction-cursor)
xmap <Leader>ca <Plug>(coc-codeaction-selected)
nmap <Leader>qf <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <Leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <Leader>re <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <Leader>cl <Plug>(coc-codelens-action)

" Map function and class text objects
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

" Mappings for CocList
nnoremap <silent><nowait> <Leader>co :<C-u>CocList outline<CR>
nnoremap <silent><nowait> <Leader>cs :<C-u>CocList -I symbols<CR>

" coc-prettier: format on save for supported filetypes
command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument

" -----------------------------------------------------------------------------
" vim-which-key Configuration
" -----------------------------------------------------------------------------

" Set timeout for which-key popup
set timeoutlen=500

" Define prefix dictionary
let g:which_key_map = {}

" Register the leader key with which-key
nnoremap <silent> <Leader> :<c-u>WhichKey ','<CR>
vnoremap <silent> <Leader> :<c-u>WhichKeyVisual ','<CR>

" Top-level mappings
let g:which_key_map[' '] = 'clear search highlight'
let g:which_key_map['w'] = 'save file'
let g:which_key_map['q'] = 'quit'
let g:which_key_map['n'] = 'next buffer'
let g:which_key_map['p'] = 'previous buffer'
let g:which_key_map['e'] = 'file explorer'
let g:which_key_map['*'] = 'grep word under cursor'
let g:which_key_map[':'] = 'command history'
let g:which_key_map['?'] = 'search history'

" Buffer mappings
let g:which_key_map['b'] = {
\   'name': '+buffer',
\   'd': 'delete buffer',
\}
" Add standalone buffer mapping
let g:which_key_map['b'] = 'list buffers'
let g:which_key_map['bd'] = 'delete buffer'

" fzf mappings
let g:which_key_map['f'] = 'find files'
let g:which_key_map['/'] = 'grep (ripgrep)'
let g:which_key_map['l'] = 'search lines'
let g:which_key_map['h'] = 'file history'
let g:which_key_map['c'] = 'commands'

" Git mappings (fzf)
let g:which_key_map['gf'] = 'git files'
let g:which_key_map['gs'] = 'git status files'

" coc.nvim mappings
let g:which_key_map['gd'] = 'go to definition'
let g:which_key_map['gt'] = 'go to type definition'
let g:which_key_map['gi'] = 'go to implementation'
let g:which_key_map['gr'] = 'find references'
let g:which_key_map['rn'] = 'rename symbol'
let g:which_key_map['ca'] = 'code actions'
let g:which_key_map['qf'] = 'quick fix'
let g:which_key_map['cf'] = 'format code'
let g:which_key_map['re'] = 'refactor'
let g:which_key_map['cl'] = 'code lens action'
let g:which_key_map['co'] = 'show outline'
let g:which_key_map['cs'] = 'search symbols'

" ALE mappings
let g:which_key_map['d'] = 'show lint error detail'

" Register the dictionary
call which_key#register(',', "g:which_key_map")

" Styling
let g:which_key_use_floating_win = 1
let g:which_key_floating_opts = { 'row': '-2', 'col': '-2', 'width': '+2' }
highlight default link WhichKey          Function
highlight default link WhichKeySeperator DiffAdded
highlight default link WhichKeyGroup     Keyword
highlight default link WhichKeyDesc      Identifier
