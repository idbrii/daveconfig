" Author:	DBriscoe (pydave@gmail.com)
" Modified: 03 Aug 2008
" Influences:
"	* JAnderson: http://blog.sontek.net/2008/05/11/python-with-a-modular-ide-vim/
"	* Whoever I got cscope from
"	* MacVim guy

" Don't load plugins if we aren't in Vim7
if version < 700
	set noloadplugins
endif

""" Settings 
set nocompatible				" Don't be compatible with vi

"""" Searching and Patterns
set ignorecase					" search is case insensitive
set smartcase					" search case sensitive if caps on 
set hlsearch					" Highlight matches to the search 

"""" Display
set background=dark			" I use dark background
set lazyredraw					" Don't repaint when scripts are running
set scrolloff=3				" Keep 3 lines below and above cursor
set ruler						" line numbers and column the cursor is on
"set number						" Show line numbering
"set numberwidth=1			" Use 1 col + 1 space for numbers
"colorscheme tango
"colorscheme carvedwood
colorscheme elflord         " Good terminal colours


" tab labels show the filename without path(tail)
set guitablabel=%N/\ %t\ %M

""" Windows
if exists(":tab")				" Try to move to other windows if changing buf
	set switchbuf=useopen,usetab
else							" Try other windows & tabs if available
	set switchbuf=useopen
endif

"""" Messages, Info, Status
set shortmess+=a				" Use [+] [RO] [w] for modified, read-only, modified
set showcmd						" Display what command is waiting for an operator
set ruler						" Show pos below the win if there's no status line
set laststatus=2				" Always show statusline, even if only 1 window
set report=0					" Notify of all whole-line changes
set visualbell					" Use visual bell (no beep)
set linebreak					" Show wrap at word boundaries and preface wrap with >>
set showbreak=>>

"""" Editing
set showmatch				" Briefly jump to the matching bracket
set matchtime=1				" For .1 seconds
"set formatoptions-=tc		" can I format for myself?? TODO
set tabstop=4				" 1 tab = x spaces
set shiftwidth=4			" (used on auto indent)
set softtabstop=4			" 4 spaces as a tab for bs/del
set smarttab				" Use tab button for tabs
set expandtab				" Use spaces, not tabs (use Ctrl-V+Tab to insert a tab)
"set autoindent				" Indent like previous line
set smartindent				" Try to be clever about indenting
"set cindent				" Really clever indenting

" we don't want to edit these type of files
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.swp
" Show these file types at the end while using :edit command
set suffixes+=.class,.exe,.o,.obj,.dat,.dll,.aux,.pdf,.gch

"""" Coding
set history=100				" 100 Lines of history
set showfulltag				" Show more information while completing tags
filetype plugin on          " Enable filetype plugins
filetype plugin indent on   " Let filetype plugins indent for me
syntax on                   " Turn on syntax highlighting
"syntax enable				" Keep current highlighting scheme
if has("spell")
    "set spell   "check spelling (z= suggestions, zg add good word, zb bad)
    syntax spell notoplevel
endif

" read tags 4 directories deep
set tags=./tags;../../../../
set tags+=$HOME/.vim/tags/python.ctags

""""" Folding
set foldmethod=syntax		" By default, use syntax to determine folds
set foldlevelstart=99		" All folds open by default

"""" Command Line
set wildmenu                " Autocomplete features in the status bar

"""" Autocommands
if has("autocmd")
augroup vimrcEx
au!
	" In plain-text files and svn commit buffers, wrap automatically at 78 chars
"	au FileType text,svn setlocal tw=78 fo+=t

	" In all files, try to jump back to the last spot cursor was in before exiting
	au BufReadPost *
		\ if line("'\"") > 0 && line("'\"") <= line("$") |
		\   exe "normal g`\"" |
		\ endif

	" Switch to the directory of the current file, unless it's a help file.
"	au BufEnter * if &ft != 'help' | silent! cd %:p:h | endif
    " Switch to directory of current file (not help files) on open.
	au BufReadPost * if &ft != 'help' | silent! cd %:p:h | endif

	" kill calltip window if we move cursor or leave insert mode
	au CursorMovedI * if pumvisible() == 0|pclose|endif
	au InsertLeave * if pumvisible() == 0|pclose|endif

	augroup END
endif

"""" Key Mappings
" bind ctrl+space for omnicompletion
"inoremap <expr> <C-Space> pumvisible() \|\| &omnifunc == '' ?
"			\ "\<lt>C-n>" :
"			\ "\<lt>C-x>\<lt>C-o><c-r>=pumvisible() ?" .
"			\ "\"\\<lt>c-n>\\<lt>c-p>\\<lt>c-n>\" :" .
"			\ "\" \\<lt>bs>\\<lt>C-n>\"\<CR>"
"imap <C-@> <C-Space>
"
" Simpler remapping. TODO: What is difference?
inoremap <C-Space> <C-x><C-o>

" Toggle the tag list bar
nmap <F4> :TlistToggle<CR>

"""" Movement
" work more logically with wrapped lines
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Ctrl + Arrows - Move around quickly
nnoremap  <c-up>     {
nnoremap  <c-down>   }
nnoremap  <c-right>  El
nnoremap  <c-left>   Bh

" Shift + Arrows - Visually Select text
"nnoremap  <s-up>     Vk
"nnoremap  <s-down>   Vj
"nnoremap  <s-right>  vl
"nnoremap  <s-left>   vh

" Use tab and shift-tab to indent in normal mode
nmap <Tab> >>
nmap <S-Tab> <<

" Easy cmdline run (normal, visual)
map \ :!<up><CR>
ounmap \

" Easy make
map <F5> :make 
map \| :make<up><CR>
ounmap \|

" Global search
map gs :%s/
vmap gs :s/

" Open preview window for tags (just jump with <C-]>)
nnoremap <C-\> :ptag <C-r><C-w><CR>

" Windows keys
nmap <C-s> :w<CR>
nmap <C-a> 1GVG
nmap <C-c> "+y
nmap <C-v> "+p
" Keep block select, but require shift
nnoremap <C-S-v> <C-v>

" Make backspace work in normal
nmap <BS> X

if &diff
" easily handle diffing 
   vnoremap < :diffget<CR>
   vnoremap > :diffput<CR>
endif

" Switch files
nmap ^ <C-^>
nmap <A-Left> :bp<CR>
nmap <A-Right> :bn<CR>


""" Extra functionality for some existing commands:

" CTRL-g shows filename and buffer number, too.
nnoremap <C-g> 2<C-g>

" <C-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" Q formats paragraphs, instead of entering ex mode
noremap Q gq

" * and # search for next/previous of selected text when used in visual mode
vnoremap g* y/<C-R>"<CR>
vnoremap g# y?<C-R>"<CR>

" <space> toggles folds opened and closed
nnoremap <space> za

" <space> in visual mode creates a fold over the marked range
"vnoremap <space> zf

" allow arrow keys when code completion window is up
"inoremap <Down> <C-R>=pumvisible() ? "\<lt>C-N>" : "\<lt>Down>"<CR>

""" Abbreviations
" General
iabbr _me DBriscoe (pydave@gmail.com)
iabbr _t  <C-R>=strftime("%H:%M:%S")<CR>
iabbr _d  <C-R>=strftime("%d %b %Y")<CR>
iabbr _dt <C-R>=strftime("%a, %d %b %Y %H:%M:%S")<CR>

" Shebangs
abbreviate shebangpy #! /usr/bin/env python
abbreviate shebangsh #! /bin/sh
abbreviate shebangbash #! /bin/bash

" macros
abbreviate #i #include
abbreviate #d #define
abbreviate D_P DBG_PRINT
abbreviate _guard_ #ifndef <CR>#define <CR><CR>#endif //<ESC>kO

" constructs
abbreviate frepeat for (int i = 0; i < 0; ++i)

" for Java: Copies type and sets up new
abbreviate jnew <ESC>BBByW$i new <ESC>pa);<ESC>hi

" for Java: makes main signature
abbreviate jmain public static void main (String[] args)

" for Java: output shortcuts
abbreviate Sout System.out.println
abbreviate Serr System.err.println

" for Java: import shortcuts
abbreviate Iawt import java.awt.*;
abbreviate Iswing import javax.swing.*;
abbreviate Ijava import java.*;<ESC>bi
