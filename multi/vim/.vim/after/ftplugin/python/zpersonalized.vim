" Personalized python settings
" Author:	DBriscoe (pydave@gmail.com)
" Influences:
"	* JAnderson: http://sontek.net/blog/detail/turning-vim-into-a-modern-python-ide

"" no tabs in python files
setlocal expandtab

"" c-indenting for python
"" Would use smartindent, but it indents # at the first column
setlocal cindent cinwords=if,elif,else,for,while,try,except,finally,def,class

"" simple indent-based folding
setlocal foldmethod=indent

compiler python

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

nnoremap <buffer> <F7> :set makeprg=nosetests<CR>:AsyncMake<CR>
function! s:set_entrypoint()
    " Use the current file and its directory and jump back there to run
    " (ensures any expected relative paths will work).
    let cur_file = expand('%:p')
    let cur_dir = fnamemodify(cur_file, ':h')
    let cur_file = fnamemodify(cur_file, ':t')
    exec 'nnoremap <F6> :lcd '. cur_dir .'<CR>:set makeprg=python\ -t\ '. cur_file .'<CR>:AsyncMake<CR>'
endf
command! -buffer PythonSetEntrypoint call s:set_entrypoint()

"" PyDoc commands (requires pydoc and python_pydoc.vim)
if exists('loaded_pydocvim')
    nnoremap <buffer> K :call ShowPyDoc('<C-R><C-W>', 1)<CR>
    xnoremap <buffer> K y:call ShowPyDoc('<C-R>"', 1)<CR>
    nnoremap <buffer> <C-k> :Pydoc <C-R><C-W>
endif

"" Quick commenting/uncommenting
xnoremap <buffer> <silent> <C-o> :s/^/#<CR>:silent nohl<CR>
xnoremap <buffer> <silent> <Leader><C-o> :s/^\([ \t]*\)#/\1/<CR>:silent nohl<CR>

" Complete is too slow in python
" Disable searching included files since that seems to be what's stalling it.
" Why isn't this smarter? -- maybe due to eclim?
set complete-=i

"" Stdlib tags
setlocal tags+=$HOME/.vim/tags/python.ctags

" Don't bother with pyflakes, it usually doesn't work anyway.
" See: https://groups.google.com/d/msg/eclim-user/KAXASg8t9MM/3HZn3fqZnJMJ
let g:eclim_python_pyflakes_warn = 0
