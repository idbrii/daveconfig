" Vim syntax file
" Language:	C#
" Maintainer:	idbrii

" Preamble {{{1

" Don't exit! I'm adding to existing syntax (vim-cs's setup in aaa-cs-official).
"if exists("b:current_syntax")
"    finish
"endif

let s:cs_cpo_save = &cpo
set cpo&vim

" Highlight basic errors with syntax {{{1

" Bad floats (0.f)
syn match csBadCodeError display "\v<\d+\.f>"

hi def link csBadCodeError Error


" idbrii Removed xml: {{{1
"syntax include @csXml syntax/xml.vim
"hi def link xmlRegion Comment

" Try something a bit different from NONE.
hi link	csParens	Delimiter
hi link	csBraces	Delimiter

" I like this attribute group, but it has potential problems:
" https://github.com/nickspoons/vim-cs/pull/5#pullrequestreview-177470208
" https://github.com/idbrii/vim-cs/blob/attribute/test/attributes.vader
syn region	csAttribute	start="^\s*\[\ze\K" end="\]\s*" contains=csString, csVerbatimString, csCharacter, csNumber, csType, csTypeOf, csTypeOfOperand, csParens, csComment
hi def link	csAttribute	Macro

" Fold Code blocks {{{1
syn region	csBlock		start="{" end="}" transparent fold


" Epilogue {{{1

" Don't set syntax! We want other files to supply most of the details.
"let b:current_syntax = "cs"

let &cpo = s:cs_cpo_save
unlet s:cs_cpo_save

" vim: ts=8
