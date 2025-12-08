" TypeScript uses 2 spaces
setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab

setlocal textwidth=100

" TypeScript-specific mappings
nnoremap <buffer> <LocalLeader>r :!npx ts-node %<CR>
nnoremap <buffer> <LocalLeader>t :!npm test<CR>
