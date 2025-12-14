" OCaml uses 2 spaces (standard convention)
setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab

setlocal textwidth=80

" OCaml-specific mappings
nnoremap <buffer> <LocalLeader>b :!dune build<CR>
nnoremap <buffer> <LocalLeader>t :!dune test<CR>
nnoremap <buffer> <LocalLeader>r :!dune exec %:t:r<CR>
nnoremap <buffer> <LocalLeader>c :!dune clean<CR>
nnoremap <buffer> <LocalLeader>u :!utop<CR>
