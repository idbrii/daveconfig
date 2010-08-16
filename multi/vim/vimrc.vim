" Author:	DBriscoe (pydave@gmail.com)
" Influences:
"	* JAnderson: http://blog.sontek.net/2008/05/11/python-with-a-modular-ide-vim/
"	* MacVim's defaults: http://macvim.org/OSX/index.php
" Notes:
" mapping Tab in normal mode breaks cscope -- adds tabs when you jump somewhere

" Don't load plugins if we aren't in Vim7
if version < 700
	set noloadplugins
endif

""" Settings
set nocompatible				" who needs vi, we've got Vim!

"""" Searching and Patterns
set ignorecase					" search is case insensitive
set smartcase					" search case sensitive if caps on
set hlsearch					" Highlight matches to the search
set incsearch					" Find as you type

"""" Display
set background=dark			" I use dark background
set lazyredraw				" Don't repaint when scripts are running
set scrolloff=3				" Keep 3 lines below and above cursor
"set number					" Show line numbering
"set numberwidth=1			" Use 1 col + 1 space for numbers
set guioptions-=T			" Disable the toolbar

if has("macunix")
    " looks good on my mac terminal
    colorscheme elflord
elseif has("win32")
    colorscheme desert
else
    " looks good on ubuntu terminal
    colorscheme carvedwood
endif
" TODO: pablo is good if you have few colors and don't like bold, but what condition would that be?


"""" Messages, Info, Status
set shortmess+=a				" Use [+] [RO] [w] for modified, read-only, modified
set showcmd						" Display what command is waiting for an operator
set ruler						" line numbers and column the cursor is on
set laststatus=2				" Always show statusline, even if only 1 window
set noequalalways               " Don't resize when closing a window
set report=0					" Notify of all whole-line changes
set visualbell					" Use visual bell (no beep)
set linebreak					" Show wrap at word boundaries and preface wrap with >>
set showbreak=>>
"set splitbelow                  " Make preview (and all other) splits appear at the bottom

"""" Editing
set nojoinspaces            " I don't use double spaces
set showmatch				" Briefly jump to the matching bracket
set matchtime=1				" For .1 seconds
"set formatoptions-=tc		" can I format for myself?? (only matters when textwidth>0)
set formatoptions+=r		" magically continue comments
set formatoptions-=o		" I tend to use o for whitespace, not continuing comments
set tabstop=4				" 1 tab = x spaces
set shiftwidth=4			" (used on auto indent)
set softtabstop=4			" 4 spaces as a tab for bs/del
set smarttab				" Use tab button for tabs
set expandtab				" Use spaces, not tabs (use Ctrl-V+Tab to insert a tab)
"set autoindent				" Indent like previous line
set smartindent				" Try to be clever about indenting
"set cindent				" Really clever indenting
if version > 600
    set backspace=start         " backspace can clear up to beginning of line
endif


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
"set tags=./tags;../../../../
" search up recursively for tags file (to root)
set tags=./tags;/


"""" Folding
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

	" In most files, jump back to the last spot cursor was in before exiting
    " (except: git commit)
	au BufReadPost * if &ft != 'gitcommit' |
		\ if line("'\"") > 0 && line("'\"") <= line("$") |
		\   exe "normal g`\"" |
		\ endif

    " Commenting blocks
    autocmd FileType build,xml,html vmap <C-o> <ESC>'<O<!--<ESC>'>o--><ESC>
    autocmd FileType java,c,cpp,cs vmap <C-o> <ESC>'<O/*<ESC>'>o*/<ESC>


	" Switch to the directory of the current file, unless it's a help file.
    " Could use BufEnter instead, but then we have constant changing pwd.
    " Use <S-e> to reload the buffer if you want to cd.
	au BufReadPost * if &ft != 'help' | silent! cd %:p:h | endif

	" kill calltip window if we move cursor or leave insert mode
	au CursorMovedI * if pumvisible() == 0|pclose|endif
	au InsertLeave * if pumvisible() == 0|pclose|endif

	augroup END
endif




"""" Completion

" bind ctrl+space for omnicompletion
inoremap <C-Space> <C-x><C-o>
" Ensure we're using all options
set completeopt=menu,preview,menuone

" SuperTab -- not currently in use
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabMappingForward = '<c-space>'
let g:SuperTabMappingBackward = '<s-c-space>'



"""" Key Mappings

" Toggle the tag list bar
nmap <F4> :TlistToggle<CR>

" Scratch file for random bits
nnoremap <F1> :sp ~/.vim-scratch<CR>
nnoremap <S-F1> :e ~/.vim-scratch<CR>

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

" Use Ctrl-Tab and Shift-Tab to indent in visual
" Also add Ctrl-t for consistency with insert mode (but keeps selection)
" Can't map Ctrl-D since that's page down
" Note: this can probably be done with Select mode, but I don't use that.
" TODO: upgrade snippetsemu and change C-t to Tab
vnoremap <C-Tab> >gv
vnoremap <C-t> >gv
vnoremap <S-Tab> <LT>gv
" Use ctrl-tab and shift-tab for indent in normal mode
nnoremap <C-Tab> >>
nnoremap <S-Tab> <<
" and insert mode
inoremap <C-Tab> <C-t>
inoremap <C-S-Tab> <C-d>


" Quick fix slashes
"	win -> unix
vnoremap <A-/> :s/\\/\//g<CR>:nohl<CR>
"	unix -> win
vnoremap <A-?> :s/\//\\/g<CR>:nohl<CR>

" Quickly find todo items
nmap <Leader>t :vimgrep TODO %<CR>

" Easy grep for current query
nmap <Leader>* :grep -e "<C-r>/"

" Easy cmdline run (normal, visual)
map <Leader>\ :!<up><CR>
ounmap <Leader>\

" Generic Header comments (requires formatoptions+=r)
"  Uses vim's commentstring to figure out the local comment character
nmap <Leader>hc ggO<C-r>=&commentstring<CR><Esc>0/%s<CR>2cl<CR> @file	<C-r>%<CR>@module	<C-r>=expand('%:p:h:t')<CR><CR><CR>@author	_me<CR>@brief	<CR><CR>Copyright (c) <C-R>=strftime("%Y")<CR> _company All Rights Reserved.<CR><Esc>3kA

" Easy make
nmap <S-F5> :make 
nmap <Leader>\| :make<up><CR>
"ounmap <Leader>\|
" For async make. Don't have to hit enter after running make.
nmap <F5> :silent make 

" Very magic global search (see \v and smagic)
nmap gs :%sm/\v
vmap gs :sm/\v
nnoremap / /\v
nnoremap ? ?\v

" Open preview window for tags (just jump with <C-]>)
nnoremap <A-]> :ptag <C-r><C-w><CR>

" Simplify most common cscope command
" (<C-\>s is defined in cscope_maps.vim)
nmap <C-\><C-\> <C-\>s

" Windows keys
nmap <C-s> :w<CR>
" change increment to allow select all
nnoremap <C-x><C-z> <C-a>
nnoremap <C-x><C-x> <C-x>
" select all
nnoremap <C-a> 1GVG
" Windows clipboard
vmap <C-c> "+y
nnoremap <C-v> "+p

" Paste last yanked item
noremap <Leader>p "0p
noremap <Leader>P "0P

" Keep block select, but require shift
nnoremap <C-S-v> <C-v>

" Make Y work like D and C
nmap Y y$

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

" Ctrl+Shift+PgUp/Dn - Move between files
nnoremap <C-S-PageDown> :next<CR>
nnoremap <C-S-PageUp> :prev<CR>
" Ctrl+PgUp/Dn - Move between quickfix marks
nnoremap <C-PageDown> :cnext<CR>
nnoremap <C-PageUp> :cprev<CR>
" Alt+PgUp/Dn - Move between location window marks
nnoremap <A-PageDown> :lnext<CR>
nnoremap <A-PageUp> :lprev<CR>

" Quickly open/close quickfix
nmap <Leader>c :cwindow<CR>

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

" <Shift-space> reloads the file
nnoremap <S-space> :e<CR>

" <space> toggles folds opened and closed
nnoremap <space> za

" <space> in visual mode creates a fold over the marked range
"vnoremap <space> zf


"""""""""""
""" Abbreviations   {{{
"" Command

" Redirect commands to new buffer
"" Puts the last g search command in a new buffer -- clobbers your c buffer
cabbrev what :redir @c<CR>:g//<CR>:redir END<CR>:new<CR>:put! c<CR><CR>
"" Puts whatever is in between in a new buffer
"" You can use ctag/cscope output, g searches, whatever! -- clobbers your c buffer
cabbrev rstart redir @c<CR>
cabbrev rend redir END<CR>:sp ~/.rend.vimscratch<CR>:put! c<CR><CR>
"" Faster ways to start search redirects. Require rend once complete.
cabbrev rg redir @c<CR>:g
cabbrev rv redir @c<CR>:v

" Diff
cabbrev diffboth diffthis<CR><C-w><C-w>:diffthis<CR>
cabbrev vdiffsp vert diffsplit

" Windowing (Full screen on my monitor)
cabbrev vert set lines=59
cabbrev large set lines=59<CR>:set columns=100

" VimShell - run sh from within a Vim buffer
cabbrev vshell runtime scripts/vimsh/vimsh.vim
cabbrev vsh runtime scripts/vimsh/vimsh.vim

"" Insert
" General
iabbrev _me DBriscoe (pydave@gmail.com)
iabbrev _company pydave
iabbrev _t  <C-R>=strftime("%H:%M:%S")<CR>
iabbrev _d  <C-R>=strftime("%d %b %Y")<CR>
iabbrev _dt <C-R>=strftime("%a, %d %b %Y %H:%M:%S")<CR>

" Shebangs
iabbrev shebangpy #! /usr/bin/env python
iabbrev shebangsh #! /bin/sh
iabbrev shebangbash #! /bin/bash



" constructs
iabbrev frepeat for (int i = 0; i < 0; ++i)

"}}}

"""""""""""
" Plugins   {{{

" SuperTab
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabMappingForward = '<c-space>'
let g:SuperTabMappingBackward = '<s-c-space>'

"""""
" LookupFile
let g:LookupFile_DisableDefaultMap = 1          " Disable defaults -- make is F5
"let g:LookupFile_MinPatLength = 6              " Is it slow enough yet?
let g:LookupFile_UpdateTime = 400               " wait a bit longer before completing
let g:LookupFile_PreserveLastPattern = 0        " what I last looked up is in bufexplorer
let g:LookupFile_EscCancelsPopup = 1            " this doesn't work! I can't get out with Esc
let g:LookupFile_AlwaysAcceptFirst = 1          " easier to pick first result
let g:LookupFile_Bufs_LikeBufCmd = 0            " Use same wildcard types as LUTags

" Like gf but use filenametags instead of path
nmap <Leader>gf :LUTags <c-r>=expand('<cfile>:t')<CR><CR>

function! FindFilenameTagsFile()
    " From our current directory, search up for filenametags
    let lookupfile = findfile('filenametags', '.;/')    " must be somewhere above us
    let lookupfile = fnamemodify(lookupfile, ':p')      " get the full path
    if filereadable(lookupfile)
        let g:LookupFile_TagExpr = string(lookupfile)
        let g:LookupFile_UsingSpecializedTags = 1   " only if the previous line is right
    else
        let g:LookupFile_UsingSpecializedTags = 0   " only if the previous line is right
    endif
endfunction
call FindFilenameTagsFile()

""" Like visual assist
" Open file
nnoremap <A-S-o> :LUTags<CR>
nnoremap <C-S-o> :LUBufs<CR>
" Open header/implementation -- gives list of files with the same name
" using Leader first because cpp.vim has faster <A-o> (and doesn't change last
" command)
nnoremap <Leader><A-o> :LookupFile<CR><C-r>#<Esc>F."_C.

" Pydoc
"  Pydoc maps conflict with \p
let no_pydoc_maps = 1
"  Highlighting is ugly
let g:pydoc_highlight = 0

"}}}


"""""""""""
" Source Control    {{{

" Git
" Don't want maps for git. Just use Normal commands
let g:git_no_map_default = 1


" Perforce
let no_perforce_maps=1
let g:p4CheckOutDefault = 1		" Yes as default
"let g:p4MaxLinesInDialog = 0	" 0 = Don't show the dialog, but do I want that?

"}}}


"""""""""""
" Functions {{{

" CopyFilenameToClipboard
" Argument: ("%") or ("%:p")
function! CopyFilenameToClipboard(filename)
    let @*=expand(a:filename)
endfunction

"}}}

" =-=-=-=-=-=
" Source local environment additions
runtime local.vim

" vim: sw=4 fdm=marker
