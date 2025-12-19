" Elixir uses 2 spaces (standard convention)
setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab

setlocal textwidth=98

" Elixir-specific mappings
nnoremap <buffer> <LocalLeader>b :!mix compile<CR>
nnoremap <buffer> <LocalLeader>t :!mix test<CR>
nnoremap <buffer> <LocalLeader>r :!mix run %<CR>
nnoremap <buffer> <LocalLeader>f :!mix format %<CR>
nnoremap <buffer> <LocalLeader>i :terminal iex -S mix<CR>
