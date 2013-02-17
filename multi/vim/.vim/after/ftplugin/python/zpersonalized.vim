" Personalized python settings
" Author:	DBriscoe (pydave@gmail.com)
" Influences:
"	* JAnderson: http://blog.sontek.net/2008/05/11/python-with-a-modular-ide-vim/

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

    let l:makeprg = &makeprg
    setlocal makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
    make
    let &makeprg = l:makeprg
endfunction

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
