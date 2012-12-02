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

"" Use an errorformat that matches Python's stack trace.
setlocal efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
"" Run :make to launch the script and load runtime errors in quickfix.
setlocal makeprg=python\ -t\ %

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
    nmap <buffer> K :call ShowPyDoc('<C-R><C-W>', 1)<CR>
    vmap <buffer> K y:call ShowPyDoc('<C-R>"', 1)<CR>
    nmap <buffer> <C-k> :Pydoc <C-R><C-W>
endif

"" Quick commenting
vmap <buffer> <C-o> :s/^/#<CR>:silent nohl<CR>

" Complete is too slow in python
" Disable searching included files since that seems to be what's stalling it.
" Why isn't this smarter? -- maybe due to eclim?
set complete-=i

"" Stdlib tags
if has("unix") || has("macunix")
    setlocal tags+=$HOME/.vim/tags/python.ctags
else
    "" Windows
    setlocal tags+=$HOME/vimfiles/tags/python.ctags
endif

