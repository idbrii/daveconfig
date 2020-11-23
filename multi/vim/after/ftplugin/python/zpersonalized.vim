" Personalized python settings
" Author:	DBriscoe (idbrii@gmail.com)
" Influences:
"	* JAnderson: http://sontek.net/blog/detail/turning-vim-into-a-modern-python-ide

"" no tabs in python files
setlocal expandtab

"" c-indenting for python
"" Would use smartindent, but it indents # at the first column
setlocal cindent cinwords=if,elif,else,for,while,try,except,finally,def,class
" see # as comments
setlocal cinoptions+=#1

"" simple indent-based folding
if &foldmethod != 'diff'
    setlocal foldmethod=indent
endif

function! PyCompileCheck()
    " Finds syntax errors in the current file and adds them to the quickfix.
    " This isn't really necessary with eclim since it does auto syntax
    " checking.

    if exists('g:current_compiler')
        let last_compiler = g:current_compiler
        unlet g:current_compiler
    endif
    compiler py_compile
    make
    if exists('last_compiler')
        exec 'compiler '. last_compiler
    endif
endfunction

" pip3 install nose2
nnoremap <buffer> <F7> :set makeprg=nose2<CR>:AsyncMake<CR>

function! s:pick_entrypoint_makeprg_safe(desired, fallback)
    " Cannot use a makeprg that already has a module entrypoint defined.
    if a:desired =~# '-m'
        return a:fallback
    else
        return a:desired
    else
endf

function! s:get_python_makeprg(module_and_args)
    if !exists("s:original_makeprg")
        let s:original_makeprg = s:pick_entrypoint_makeprg_safe(&makeprg, 'python')
    endif

    let python = s:pick_entrypoint_makeprg_safe(&makeprg, s:original_makeprg)

    let entrypoint_makeprg = (python .. ' -m' .. a:module_and_args)
    let entrypoint_makeprg = substitute(entrypoint_makeprg, '%', '', '')
    return entrypoint_makeprg
endf

function! s:set_module_entrypoint(should_be_async)
    " Use the current file as module. Will be invoked from this directory too.
    let cur_file = expand('%:p')
    let cur_module = fnamemodify(cur_file, ':t:r')

    call s:set_entrypoint(a:should_be_async, s:get_python_makeprg(cur_module))
endf

function! s:set_test_entrypoint(should_be_async, test_name)
    let cur_file = expand('%:p')
    let cur_dir = fnamemodify(cur_file, ':h')
    let cur_module = fnamemodify(cur_file, ':t:r')
    let specific_test = ''
    if !empty(a:test_name)
        let specific_test = printf(" %s.%s", cur_module, a:test_name)
    endif
    
    call s:set_entrypoint(a:should_be_async, 'nose2 -s '.. cur_dir .. specific_test)
endf

function! s:set_entrypoint(should_be_async, entrypoint_makeprg)
    let should_be_async = a:should_be_async

    " Will jump back current directory to run (ensures any expected relative
    " paths will work). You must have a reasonable makeprg before invoking.
    let cur_file = expand('%:p')
    let cur_dir = fnamemodify(cur_file, ':h')

    function! DavidProjectBuild() closure
        update
        call execute('lcd '. cur_dir)
        let &makeprg = a:entrypoint_makeprg
        " Tracebacks have most recent call last.
        let g:asyncrun_exit = 'call david#window#show_last_error_without_jump()'
        if should_be_async
            " asyncrun doesn't correctly handle my multi-line errors, but
            " sometimes async is nice.
            AsyncMake
        else
            make!
            copen
            exec g:asyncrun_exit
        endif
    endf
    command! ProjectMake call DavidProjectBuild()
    command! ProjectRun  call DavidProjectBuild()
endf
" Defaults to async. Use bang for :make.
command! -bang -buffer PythonSetEntrypoint call s:set_module_entrypoint(<bang>1)
" Pass "TestClass.test_function" to run that specific test.
command! -bang -buffer -nargs=* PythonTest call s:set_test_entrypoint(<bang>1, <q-args>)

"" PyDoc commands (requires pydoc and python_pydoc.vim)
if exists(':PyDoc') == 2
    command! -nargs=1 Pydoc     PyDoc <args>
    " nnoremap K covered by pydoc
    xnoremap <buffer> K "cy:PyDocGrep <C-R>c<CR>
    " Approximate unity-docs. Not sure how to get pydoc in unite.
    nnoremap <buffer> <Leader>ok :Pydoc <C-R><C-W>
endif

"" Quick commenting/uncommenting.
" ~ prefix from https://www.reddit.com/r/vim/comments/4ootmz/what_is_your_little_known_secret_vim_shortcut_or/d4ehmql
xnoremap <buffer> <silent> <C-o> :s/^/#\~ <CR>:silent nohl<CR>
xnoremap <buffer> <silent> <Leader><C-o> :s/^\([ \t]*\)#\~ /\1/<CR>:silent nohl<CR>

" Complete is too slow in python
" Disable searching included files since that seems to be what's stalling it.
" Why isn't this smarter? -- maybe due to eclim?
set complete-=i

"" stdlib tags
" ctags -R -f ~/.vim/tags/python.ctags --c-kinds=+p --fields=+S /usr/lib/python/
setlocal tags+=$HOME/.vim/tags/python.ctags

" Don't bother with pyflakes, it usually doesn't work anyway.
" See: https://groups.google.com/d/msg/eclim-user/KAXASg8t9MM/3HZn3fqZnJMJ
let g:eclim_python_pyflakes_warn = 0

" Use python3 if I asked for it.
function! s:DoesWantPy3()
    let first_line = getline(1)
    let is_shebang = first_line =~# '^#!'
    if is_shebang
        if match(first_line, 'python3') >= 0 
            return v:true
        elseif match(first_line, 'python2') >= 0 
            return v:false
        endif
    endif
    return exists('&pyxversion') && &pyxversion == 3
endf
if s:DoesWantPy3() && &makeprg !~# 'python3' && executable('python3')
    let b:autocompiler_skip_detection = 1
    compiler python
    let &l:makeprg = substitute(&l:makeprg, 'python', 'python3', '')
    let g:ale_python_flake8_executable = 'python3'
    if executable('pydoc3')
        let g:pydoc_cmd = 'pydoc3'
    endif
else
    let g:ale_python_flake8_executable = 'python'
endif

