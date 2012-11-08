" Don't indent namespaces in cpp
"
" Source: http://stackoverflow.com/questions/2549019/how-to-avoid-namespace-content-indentation-in-vim/2549224#2549224
" Which was based on the Google-style cpp: http://www.vim.org/scripts/script.php?script_id=2636
function! IndentNamespace()
  let l:cline_num = line('.')
  let l:pline_num = prevnonblank(l:cline_num - 1)
  let l:pline = getline(l:pline_num)
  let l:retv = cindent('.')
  while l:pline =~# '\(^\s*{\s*\|^\s*//\|^\s*/\*\|\*/\s*$\)'
    let l:pline_num = prevnonblank(l:pline_num - 1)
    let l:pline = getline(l:pline_num)
  endwhile
  if l:pline =~# '^\s*namespace.*'
    let l:retv = 0
  endif
  return l:retv
endfunction

setlocal indentexpr=IndentNamespace()

