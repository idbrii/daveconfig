""" Some python code for use in vim
"""

if exists('loaded_pycode')
    finish
endif
let loaded_pycode = 1


if has("python")
    python << EOF

# add breakpoints for python
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

vim.command( 'noremap <buffer> <F9> :py SetBreakpoint()<CR>')

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

vim.command('noremap <buffer> <S-F9> :py RemoveBreakpoints()<CR>')

import os
import sys
import vim
# add python libs to vim path
for p in sys.path:
    if os.path.isdir(p):
        vim.command(r"setlocal path+=%s" % (p.replace(" ", r"\ ")))

import vim
# evaluate selected text via python
def EvaluateCurrentRange():
    eval(compile('\n'.join(vim.current.range),'','exec'),globals())

vim.command('noremap <buffer> <Leader>v; :py EvaluateCurrentRange()<CR>')

EOF
endif
