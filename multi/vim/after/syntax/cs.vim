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

" Don't add special highlight to end colons.
hi link	csEndColon	NONE
" Don't like operators looking like constants.
hi link	csLogicSymbols	Operator
" Don't highlight same type two different ways:
" static List<string> m_Stuff = new List<string>();
hi link	csNewType	NONE
" I don't think these should be highlighted differently or brightly.
hi link	csParens	Delimiter
hi link	csBraces	Delimiter


" Fold Code blocks {{{1
syn region	csBlock		start="{" end="}" transparent fold


" Epilogue {{{1

" Don't set syntax! We want other files to supply most of the details.
"let b:current_syntax = "cs"

let &cpo = s:cs_cpo_save
unlet s:cs_cpo_save

" vim: ts=8
