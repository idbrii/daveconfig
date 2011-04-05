" Personalized python settings
" Author:	DBriscoe (pydave@gmail.com)
" Influences:
"	* JAnderson: http://blog.sontek.net/2008/05/11/python-with-a-modular-ide-vim/

"" no tabs in python files
setlocal expandtab

"" smart indenting for python
setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

"" simple indent-based folding
setlocal foldmethod=indent

"" allows us to run :make and get syntax errors for our python scripts
setlocal makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
setlocal efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

"" PyDoc commands (requires pydoc and python_pydoc.vim)
if exists('loaded_pydocvim')
    nmap <buffer> K :call ShowPyDoc('<C-R><C-W>', 1)<CR>
    vmap <buffer> K y:call ShowPyDoc('<C-R>"', 1)<CR>
    nmap <buffer> <C-k> :Pydoc <C-R><C-W>
endif

"" Quick commenting
vmap <C-o> :s/^/#<CR>:silent nohl<CR>

"" Stdlib tags
if has("unix") || has("macunix")
    setlocal tags+=$HOME/.vim/tags/python.ctags
else
    "" Windows
    setlocal tags+=$HOME/vimfiles/tags/python.ctags
endif

