
" See ~/.vim/scripts/buildtags for how lua tags are generated.
setlocal tags+=./lua.tags;/

" lua-xolox turns this on but I find it annoying.
setlocal fo-=o

"" Quick commenting/uncommenting.
" ~ prefix from https://www.reddit.com/r/vim/comments/4ootmz/what_is_your_little_known_secret_vim_shortcut_or/d4ehmql
xnoremap <buffer> <silent> <C-o> :s/^/--\~ <CR>:silent nohl<CR>
xnoremap <buffer> <silent> <Leader><C-o> :s/^\([ \t]*\)--\~ /\1/<CR>:silent nohl<CR>

" don't let lua-xolox clobber my map.
nnoremap <buffer> <F1> :<C-u>sp ~/.vim-aside<CR>
"inoremap <buffer> <F1> <Esc>

" Omnicompletion in lua requires vim lua to load modules and I'm usually
" targetting a different lua. Use tags instead (no scope intelligence, but
" better than nothing). Omnicompletion is helpful in expanding modules, but
" that kicks in automatically, so that's good enough.
" For some reason tag completion clears what we've inserted (I guess to show
" partial tag matches), but I don't want that, so restore it.
inoremap <buffer> <C-Space> <C-o>"cyb<C-o>e<Right><C-x><C-]><C-r>c

" Files may be opened with diff mode before this 'after' file is sourced.
" Ensure we don't clobber a more relevant mode.
if &foldmethod != 'diff'
    " Vim's lua syntax doesn't include fold information, so use indent instead.
    setlocal foldmethod=indent
endif
