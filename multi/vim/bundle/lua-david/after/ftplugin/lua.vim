
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

" don't let lua-xolox clobber my map.
nnoremap <buffer> <F1> :<C-u>sp ~/.vim-aside<CR>
"inoremap <buffer> <F1> <Esc>

" Omnicompletion in lua requires vim lua to load modules and I'm usually
" targetting a different lua. Use tags instead (no scope intelligence, but
" better than nothing). Omnicompletion is helpful in expanding modules, but
" that kicks in automatically, so that's good enough.
inoremap <buffer> <C-Space> <C-x><C-]>

if lsp#get_server_status('lua-lsp') == 'running' || lsp#get_server_status('emmylua-ls') == 'running'
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

    if a:makeprg =~# '^lovec\?\>'
        " Don't have a better way to distinguish love files, so use this to
        " configure checker properly.
        let g:ale_lua_luacheck_options .= ' --std love+luajit'
        let entrypoint_makeprg = (lua .' '. cur_dir)
    else
        let entrypoint_makeprg = (lua .' '. cur_file)
    endif
    

    let entrypoint_makeprg = substitute(entrypoint_makeprg, '%', '', '')

    function! DavidProjectBuild() closure
        update
        call execute('lcd '. cur_dir)
        let &makeprg = entrypoint_makeprg
        " Use AsyncRun instead of AsyncMake so we can pass cwd and ensure
        " callstacks are loaded properly.
        call execute('AsyncRun -program=make -auto=make -cwd='. cur_dir .' @')
    endf

    command! ProjectMake call DavidProjectBuild()
    command! ProjectRun  call DavidProjectBuild()

    " Clobber current project settings.
    silent! unlet g:david_project_filelist
    let g:david_project_root = fnamemodify(cur_file, ':h')
    call LocateAll()
    NotGrepRecursiveFrom .
    " I put code in ./src/
    let g:inclement_n_dir_to_trim = 2
    let g:inclement_after_first_include = 1
    let g:inclement_src_root = g:david_project_root ..'/src/'
endf
function! s:GetLoveCmd()
    if has('win32')
        " Lovec does a better job of outputting to the console on Windows.
        return 'lovec'
    else
        return 'love'
    endif
endf
command! -buffer LuaLoveSetEntrypoint call s:set_entrypoint(s:GetLoveCmd() .' --console %')
command! -buffer LuaSetEntrypoint call s:set_entrypoint('')
