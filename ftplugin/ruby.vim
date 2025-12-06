" Ruby uses 2 spaces
setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab

setlocal textwidth=120

" Ruby-specific mappings
nnoremap <buffer> <LocalLeader>r :!ruby %<CR>
nnoremap <buffer> <LocalLeader>t :!bundle exec rspec<CR>
