
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
"
" Tag completion clears what we've inserted (because some tags are functions
" and they start with 'function' instead of the function name), but I don't
" want that, so restore it.
function! s:LuaGrabCompletionWord()
    let q_bak = @"
    normal! yiw
    let g:lua_david_yanked = @"

    let @" = q_bak
endf
inoremap <buffer> <C-Space> <C-o>:call <SID>LuaGrabCompletionWord()<CR><C-o>e<Right><C-x><C-]><C-r>=g:lua_david_yanked<CR>

if lsp#get_server_status('lua-lsp') == 'running'
    setlocal omnifunc=lsp#complete
    " fall back to default omnicompletion
    iunmap <buffer> <C-Space>
    " remove xoloc map
    silent! iunmap <buffer> .
endif

" Files may be opened with diff mode before this 'after' file is sourced.
" Ensure we don't clobber a more relevant mode.
if &foldmethod != 'diff'
    " Vim's lua syntax doesn't include fold information, so use indent instead.
    setlocal foldmethod=indent
endif


" Global entrypoint
function! s:set_entrypoint(makeprg)
    " Use the current file and its directory and jump back there to run
    " (ensures any expected relative paths will work).
    let cur_file = expand('%:p')
    let cur_dir = fnamemodify(cur_file, ':h')
    let cur_module = fnamemodify(cur_file, ':t:r')

    if !exists("s:original_makeprg")
        let s:original_makeprg = &makeprg
    endif

    if len(a:makeprg)
        let lua = a:makeprg
    else
        let lua = s:original_makeprg
    endif

    if a:makeprg =~# '^love\>'
        " Don't have a better way to distinguish love files, so use this to
        " configure checker properly.
        let g:ale_lua_luacheck_options .= ' --std love'
    endif
    

    let entrypoint_makeprg = (lua .' '. cur_dir)
    let entrypoint_makeprg = substitute(entrypoint_makeprg, '%', '', '')

    exec 'nnoremap <F6> :update<Bar>lcd '. cur_dir .'<CR>:let &makeprg="'. entrypoint_makeprg .'"<CR>:AsyncMake<CR>'
endf
command! -buffer LuaLoveSetEntrypoint call s:set_entrypoint('love %')
command! -buffer LuaSetEntrypoint call s:set_entrypoint('')
