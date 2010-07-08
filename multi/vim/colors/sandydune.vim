" Vim color file
" Maintainer:	pydave <pydave@gmail.com>
" Last Change:	06 Jul 2010
" Origin:   Based on desert.vim
" Version:	sandydune.vim

" cool help screens
" :he group-name
" :he highlight-groups
" :he cterm-colors

set background=dark
if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear
    if exists("syntax_on")
	syntax reset
    endif
endif
let g:colors_name="desert"

hi Normal	guifg=White guibg=grey20

" highlight groups {{{
hi Cursor	guibg=khaki guifg=slategrey
"hi CursorIM
"hi Directory
"hi DiffAdd
"hi DiffChange
"hi DiffDelete
"hi DiffText
"hi ErrorMsg
hi VertSplit	guibg=#c2bfa5 guifg=grey50 gui=none
hi Folded	guibg=grey30 guifg=gold
hi FoldColumn	guibg=grey30 guifg=tan
hi IncSearch	guifg=slategrey guibg=khaki
"hi LineNr
hi ModeMsg	guifg=goldenrod
hi MoreMsg	guifg=SeaGreen
hi NonText	guifg=LightBlue guibg=grey30
hi Question	guifg=springgreen
hi Search	guibg=peru guifg=wheat
hi SpecialKey	guifg=yellowgreen
hi StatusLine	guibg=#c2bfa5 guifg=black gui=none
hi StatusLineNC	guibg=#c2bfa5 guifg=grey50 gui=none
hi Title	guifg=indianred
"hi Visual	gui=none guifg=khaki guibg=olivedrab
hi Visual	gui=none guifg=lightgrey guibg=black
"hi VisualNOS
hi WarningMsg	guifg=salmon
"hi WildMenu
"hi Menu
"hi Scrollbar
"hi Tooltip
"}}}

" syntax highlighting groups {{{
" http://www.tayloredmktg.com/rgb/
hi Comment	guifg=SkyBlue
hi Constant	guifg=#ffa0a0
hi String	guifg=#ffa0c0	"a string constant: "this is a string"
"Character	guifg=#000000	"a character constant: 'c', '\n'
"Number		guifg=#000000	"a number constant: 234, 0xff
"Boolean	guifg=#000000	"a boolean constant: TRUE, false
hi Float	guifg=#ffc0b0	"a floating point constant: 2.3e10

"hi Identifier	guifg=palegreen
hi Identifier	guifg=#d0ffe0   " Used for cpp custom member/static function
hi Function	    guifg=#b0e0b0   " Used for cpp custom function definition

"hi Statement	guifg=khaki     " break, return, and all below
hi Statement	guifg=palegoldenrod     " break, return, and all below
hi Conditional	guifg=yellow	"if, then, else, endif, switch, etc.
hi Repeat		guifg=orange	"for, do, while, etc.
hi Label		guifg=gold		"case, default, etc.
hi Operator     guifg=goldenrod	""sizeof", "+", "*", etc.
"hi Keyword	    guifg=#000000	"any other keyword (never used?)
hi Exception	guifg=orangered	"try, catch, throw

hi PreProc	    guifg=tan
hi Define	    guifg=tan   	"named constants
hi Macro	  	guibg=grey21 guifg=sandybrown       "preprocessor #define
hi PreCondit	guibg=grey21 guifg=peru         	"preprocessor #if, #else, #endif, etc.
hi Include	    guibg=grey21 guifg=chocolate

"almost white
"hi Include	guifg=beige

hi Type		guifg=darkkhaki
"StorageClass	guifg=#000000	"static, register, volatile, etc.
"Structure	guifg=#000000	"struct, union, enum, etc.
"darkkhaki=#bdb76b
hi Typedef	guifg=#cdc79b

hi Special	guifg=beige
"SpecialChar	guifg=#000000	"special character in a constant
"Tag		guifg=#000000	"you can use CTRL-] on this
"Delimiter	guifg=#000000	"character that needs attention
"SpecialComment	guifg=#000000	"special things inside a comment
"Debug		guifg=#000000	"debugging statements

"hi Underlined

hi Ignore	guifg=grey40
"hi Error
hi Todo		guifg=orangered guibg=yellow2

" }}}

" color terminal definitions {{{
hi SpecialKey	ctermfg=darkgreen
hi NonText	cterm=bold ctermfg=darkblue
hi Directory	ctermfg=darkcyan
hi ErrorMsg	cterm=bold ctermfg=7 ctermbg=1
hi IncSearch	cterm=NONE ctermfg=yellow ctermbg=green
hi Search	cterm=NONE ctermfg=grey ctermbg=blue
hi MoreMsg	ctermfg=darkgreen
hi ModeMsg	cterm=NONE ctermfg=brown
hi LineNr	ctermfg=3
hi Question	ctermfg=green
hi StatusLine	cterm=bold,reverse
hi StatusLineNC cterm=reverse
hi VertSplit	cterm=reverse
hi Title	ctermfg=5
hi Visual	cterm=reverse
hi VisualNOS	cterm=bold,underline
hi WarningMsg	ctermfg=1
hi WildMenu	ctermfg=0 ctermbg=3
hi Folded	ctermfg=darkgrey ctermbg=NONE
hi FoldColumn	ctermfg=darkgrey ctermbg=NONE
hi DiffAdd	ctermbg=4
hi DiffChange	ctermbg=5
hi DiffDelete	cterm=bold ctermfg=4 ctermbg=6
hi DiffText	cterm=bold ctermbg=1
hi Comment	ctermfg=darkcyan
hi Constant	ctermfg=brown
hi Special	ctermfg=5
hi Identifier	ctermfg=6
hi Statement	ctermfg=3
hi PreProc	ctermfg=5
hi Type		ctermfg=2
hi Underlined	cterm=underline ctermfg=5
hi Ignore	cterm=bold ctermfg=7
hi Ignore	ctermfg=darkgrey
hi Error	cterm=bold ctermfg=7 ctermbg=1
" }}}


" vim: sw=4 fdm=marker
