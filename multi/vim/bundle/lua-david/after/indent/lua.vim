" Intended to run on top of vim-lua's indent.
" Adds chained function calls:
"    local data = self.kitchen
"        :getContents()
"        :getCheese()
"        :enjoyCheese(self
"            :mouth()
"            :open()
"            :extendTongue())
"        :eatCheese()
"        :digestCheese()
" https://github.com/tbastos/vim-lua
" TODO: I've submitted this as a PR at tbastos/vim-lua, so remove this file
" when that is merged.
setlocal indentexpr=DavidGetLuaIndent(v:lnum)
let s:chained_func_call = "^\\v\\s*:\\w+[({\"']"

function s:IsInCommentOrString(lnum, col)
  return synIDattr(synID(a:lnum, a:col, 1), 'name') =~# 'luaCommentLong\|luaStringLong'
        \ && !(getline(a:lnum) =~# '^\s*\%(--\)\?\[=*\[') " opening tag is not considered 'in'
endfunction

" Find line above 'lnum' that isn't blank, in a comment or string.
function s:PrevLineOfCode(lnum)
  let lnum = prevnonblank(a:lnum)
  while s:IsInCommentOrString(lnum, 1)
    let lnum = prevnonblank(lnum - 1)
  endwhile
  return lnum
endfunction

" Gets line contents, excluding trailing comments.
function s:GetContents(lnum)
  return substitute(getline(a:lnum), '\v\m--.*$', '', '')
endfunction

function! s:IsChainedLine(lnum)
    return getline(a:lnum) =~# '^\s*:\w'
endfunction

function! DavidGetLuaIndent(lnum)
  " if the line is in a long comment or string, don't change the indent
  if s:IsInCommentOrString(a:lnum, 1)
    return -1
  endif

  let prev_line = s:PrevLineOfCode(a:lnum - 1)
  if prev_line == 0
    " this is the first non-empty line
    return 0
  endif

  let i = 0
  let contents_cur = s:GetContents(a:lnum)
  let contents_prev = s:GetContents(prev_line)
  " if the current line chains a function call to previous unchained line
  if contents_prev !~# s:chained_func_call && contents_cur =~# s:chained_func_call
    let i += 1
  endif

  " if the current line chains a function call to previous unchained line
  if contents_prev =~# s:chained_func_call && contents_cur !~# s:chained_func_call
    let i -= 1
  endif
  let indent = GetLuaIndent()
  return indent + shiftwidth() * i
endf

