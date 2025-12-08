" Go uses tabs, not spaces
setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal noexpandtab

setlocal textwidth=120

" Go-specific mappings
nnoremap <buffer> <LocalLeader>r :!go run %<CR>
nnoremap <buffer> <LocalLeader>t :!go test ./...<CR>
nnoremap <buffer> <LocalLeader>b :!go build<CR>
