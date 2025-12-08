" Rust uses 4 spaces
setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal expandtab

setlocal textwidth=100

" Rust-specific mappings
nnoremap <buffer> <LocalLeader>r :!cargo run<CR>
nnoremap <buffer> <LocalLeader>t :!cargo test<CR>
nnoremap <buffer> <LocalLeader>b :!cargo build<CR>
nnoremap <buffer> <LocalLeader>c :!cargo check<CR>
