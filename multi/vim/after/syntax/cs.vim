" Vim syntax file
" Language:	C#
" Maintainer:	idbrii

" Don't exit! I'm adding to existing syntax (omnisharp's setup).
"if exists("b:current_syntax")
"    finish
"endif

let s:cs_cpo_save = &cpo
set cpo&vim

" Highlight basic errors with syntax
syn match csBadCodeError display "\d\.f"
hi def link csBadCodeError Error

" idbrii Removed xml:
"syntax include @csXml syntax/xml.vim
"hi def link xmlRegion Comment


" Fold Code blocks
syn region	csBlock		start="{" end="}" transparent fold


" Don't set syntax! We want other files to supply most of the details.
"let b:current_syntax = "cs"

let &cpo = s:cs_cpo_save
unlet s:cs_cpo_save

" vim: ts=8
