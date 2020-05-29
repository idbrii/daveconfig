""" Some python code for use in vim
"""

pyx import davidvim

nnoremap <buffer> <F9>       :<C-u>pyx davidvim.SetBreakpoint()<CR>
nnoremap <buffer> <S-F9>     :<C-u>pyx davidvim.RemoveBreakpoints()<CR>
nnoremap <buffer> <Leader>v; :<C-u>pyx davidvim.EvaluateCurrentRange()<CR>

