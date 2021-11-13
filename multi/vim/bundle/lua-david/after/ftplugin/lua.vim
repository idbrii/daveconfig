
" See ~/.vim/scripts/buildtags for how lua tags are generated.
setlocal tags+=./lua.tags;/

" lua-xolox turns this on but I find it annoying.
setlocal fo-=o

" Lua uses lots of : so assume no URIs.
" TODO: iskeyword-=: before calling?
nmap <buffer> gx <Plug>(openbrowser-search)
" Let vmap use smart search since I'm being explicit.

"" Quick commenting/uncommenting.
" ~ prefix from https://www.reddit.com/r/vim/comments/4ootmz/what_is_your_little_known_secret_vim_shortcut_or/d4ehmql
xnoremap <buffer> <silent> <C-o> :s/^/--\~ <CR>:silent nohl<CR>
xnoremap <buffer> <silent> <Leader><C-o> :s/^\([ \t]*\)--\~ /\1/<CR>:silent nohl<CR>

nnoremap <buffer> <Leader>ji :<C-u>NotGrep require.*\b<C-r>=expand('%:t:r')<CR>\b<CR>

" don't let lua-xolox clobber my map.
nnoremap <buffer> <F1> :<C-u>sp ~/.vim-aside<CR>
"inoremap <buffer> <F1> <Esc>

" Omnicompletion in lua requires vim lua to load modules and I'm usually
" targetting a different lua. Use tags instead (no scope intelligence, but
" better than nothing). Omnicompletion is helpful in expanding modules, but
" that kicks in automatically, so that's good enough.
inoremap <buffer> <C-Space> <C-x><C-]>

if lsp#get_server_status() =~# '\v<lua>.*running'
    setlocal omnifunc=lsp#complete
    " fall back to default omnicompletion
    iunmap <buffer> <C-Space>
endif

" Files may be opened with diff mode before this 'after' file is sourced.
" Ensure we don't clobber a more relevant mode.
if &foldmethod != 'diff'
    " Vim's lua syntax doesn't include fold information, so use indent instead.
    setlocal foldmethod=indent
endif


command! -buffer -nargs=* LuaLoveSetEntrypoint call david#lua#runner#set_entrypoint(david#lua#runner#GetLoveCmd() ..' --console % '.. <q-args>)
command! -buffer LuaSetEntrypoint call david#lua#runner#set_entrypoint('')
