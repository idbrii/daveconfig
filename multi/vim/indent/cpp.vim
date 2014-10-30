" Vim indent file
" Language:	C++
" Maintainer:	Konstantin Lepa <konstantin.lepa@gmail.com>
" Last Change:	2010 May 20
" Version: 1.0.1
" Source: http://www.vim.org/scripts/script.php?script_id=2636
"
" DavidNote:
" According to the plugin description, this script is partially designed to do
" no indentation in a namespace. The behavior doesn't actually work. I'm
" not sure if I want that anymore.
"
" I looked at version 1.1.0 and it's a significant refactor that now does no
" indentation in a namespace.
"
" The script page also notes that indenting of C++ namespaces added in 7.3.202
" (cino-N).
" 
"
" Changes {{{
" 1.0.1 2010-05-20
"   Added some changes. Thanks to Eric Rannaud <eric.rannaud@gmail.com>
"
"}}}

if exists("b:did_indent")
   finish
endif
let b:did_indent = 1

function! GoogleCppIndent_aux(line_num)
  let l:cline_num = a:line_num
  echo l:cline_num
  let l:pline_num = prevnonblank(l:cline_num - 1)
  let l:pline = getline(l:pline_num)
  " Test to avoid indenting to 0 the content of comments that follow a
  " 'namespace'.
  " Without the test, you get:
  "   namespace n {
  "   /*
  "   * Comment: there should be spaces before the '*', depending on the
  "   * cinoptions=cN.
  "   *
  "   */
  " So, if current line is right after a comment, go find the first non-blank,
  " non-comment line before us, as in your code.
  " Otherwise, use cindent(prevnonblank(l:cline_num - 1), which works
  " OK even if current line is in a comment.
  if l:pline =~# '\(^\s*//\|^\s*\*/\s*$\)'
    while l:pline =~# '\(^\s*//\|^\s*\*/\s*$\|^\s*/\*\|^\s*\*\)'
      let l:pline_num = prevnonblank(l:pline_num - 1)
      let l:pline = getline(l:pline_num)
    endwhile
  endif

  let l:retv = cindent(l:cline_num)
  if l:pline =~# '^\s*template.*'
    " Call recursively, in case 'template' follows right after a 'namespace'.
    let l:retv = GoogleCppIndent_aux(l:pline_num)
  elseif l:pline =~# '^\s*namespace.*'
    let l:retv = 0
  endif

  return l:retv
endfunction

function! GoogleCppIndent()
  let l:cline_num = line('.')
  " Auxiliary function to permit recursive calls.
  return GoogleCppIndent_aux(l:cline_num)
endfunction

"function! GoogleCppIndent()
"  let l:cline_num = line('.')
"  let l:pline_num = prevnonblank(l:cline_num - 1)
"  let l:pline = getline(l:pline_num)
"  while l:pline =~# '\(^\s*{\s*\|^\s*//\|^\s*/\*\|\*/\s*$\)'
"    let l:pline_num = prevnonblank(l:pline_num - 1)
"    let l:pline = getline(l:pline_num)
"  endwhile
"  let l:retv = cindent('.')
"  if l:pline =~# '^\s*template.*'
"    let l:retv = cindent(l:pline_num)
"  elseif l:pline =~# '^\s*namespace.*'
"    let l:retv = 0
"  endif
"
"  return l:retv
"endfunction

"" David: Disable these because I want to use my global settings
"setlocal shiftwidth=2
"setlocal tabstop=2
"setlocal softtabstop=2
"setlocal expandtab
"setlocal textwidth=80
"setlocal nowrap

setlocal cindent
"setlocal cinoptions=h1,l1,g1,t0,i4,+4,(0,w1,W4
"" David:
" * Use i0 to do no extra indents in ctor initialization lists.
" * g0 for no indent of visibility labels and no h1 to use normal indent after
" them.
setlocal cinoptions=l1,g0,t0,i0,+4,(0,w1,W4

" Going through indent options to try to figure out what I want.
" TODO: Finish this and apply it. I can probably remove everything else.
" 
" unindented case labels
" unindented visibility labels
" match indentation of brace continuations
" unclosed parentheses mark the indent position...
" ...unless they end a line (then use previous scope)
" use "java anonymous classes" aka lambdas
"setlocal cinoptions=:0,g0,(0,w1,Ws,j1

" To use "java anonymous classes" aka mediocre lambdas
setlocal cinoptions+=j1


"For now, disable this custom indent behavior.
"" Disable indentation in namespaces:
"if v:version >= 704
"    setlocal cinoptions+=N-s
"else
"    setlocal indentexpr=GoogleCppIndent()
"endif

let b:undo_indent = "setl sw< ts< sts< et< tw< wrap< cin< cino< inde<"

