" Highlight verbosity tags in log files.

" quit when a syntax file was already loaded
if exists("b:current_syntax")
	finish
endif

let s:cpo_save=&cpo
set cpo&vim

" These are the defaults for python.logging
syn match logDebug    '\v\C<DEBUG>'
syn match logInfo     '\v\C<INFO>'
syn match logWarning  '\v\C<WARNING>'
syn match logError    '\v\C<ERROR>'
syn match logCritical '\v\C<CRITICAL>'

" Synonyms.
syn match logCritical '\v\C<FATAL>'


" These symbols are picked based on how prominent I think they should be in
" your code. Worked okay on several colorschemes I tried.
hi def link logDebug    Comment
hi def link logInfo     Define
hi def link logWarning  Special
hi def link logError    Exception
hi def link logCritical Error


let b:current_syntax = "log"

let &cpo=s:cpo_save
unlet s:cpo_save

