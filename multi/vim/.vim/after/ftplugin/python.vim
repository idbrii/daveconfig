" Author:	DBriscoe (pydave@gmail.com)
" Influences:
"	* JAnderson: http://blog.sontek.net/2008/05/11/python-with-a-modular-ide-vim/

if has("python")
    "" add breakpoints for python 
    python << EOF
import vim
def SetBreakpoint():
    import re
    nLine = int( vim.eval( 'line(".")'))

    strLine = vim.current.line
    strWhite = re.search( '^(\s*)', strLine).group(1)

    vim.current.buffer.append(
       "%(space)spdb.set_trace() %(mark)s Breakpoint %(mark)s" %
         {'space':strWhite, 'mark': '#' * 30}, nLine - 1)

    for strLine in vim.current.buffer:
        if strLine == "import pdb":
            break
    else:
        vim.current.buffer.append( 'import pdb', 0)
        vim.command( 'normal j1')

vim.command( 'map <f9> :py SetBreakpoint()<cr>')

def RemoveBreakpoints():
    import re

    nCurrentLine = int( vim.eval( 'line(".")'))

    nLines = []
    nLine = 1
    for strLine in vim.current.buffer:
        if strLine == 'import pdb' or strLine.lstrip()[:15] == 'pdb.set_trace()':
            nLines.append( nLine)
        nLine += 1

    nLines.reverse()

    for nLine in nLines:
        vim.command( 'normal %dG' % nLine)
        vim.command( 'normal dd')
        if nLine < nCurrentLine:
            nCurrentLine -= 1

    vim.command( 'normal %dG' % nCurrentLine)

vim.command('map <s-f9> :py RemoveBreakpoints()<cr>')
EOF

    "" add python libs to vim path
    python << EOF
import os
import sys
import vim
for p in sys.path:
    if os.path.isdir(p):
        vim.command(r"setlocal path+=%s" % (p.replace(" ", r"\ ")))
EOF

    "" evaluate selected text via python
    python << EOF
import vim
def EvaluateCurrentRange():
    eval(compile('\n'.join(vim.current.range),'','exec'),globals())
EOF
    map <C-h> :py EvaluateCurrentRange()<CR>
endif

"" no tabs in python files
setlocal expandtab

"" smart indenting for python
setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

"" simple indent-based folding
setlocal foldmethod=indent

"" allows us to run :make and get syntax errors for our python scripts
setlocal makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
setlocal efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

"" PyDoc commands (requires python_pydoc.vim)
nmap  K :call ShowPyDoc('<C-R><C-W>', 1)<CR> 
vmap  K y:call ShowPyDoc('<C-R>"', 1)<CR> 

"" Stdlib tags
if has("unix")
    setlocal tags+=$HOME/.vim/tags/python.ctags
else
    "" Windows
    setlocal tags+=$HOME/vimfiles/tags/python.ctags
endif

