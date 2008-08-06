"Last updated:
" Sat Mar  1 17:32:46 EST 2008
"
set nocompatible " who needs vi, we've got Vim!
"set autoindent  " Indent like previous line
set smartindent " Try to be clever about indenting
"set cindent     " Really clever indenting
set sw=4		"set tab width to 3 spaces
set tabstop=4	"set tabstop to be the same as 'tab' width
set smarttab	"use tab button for tabs
set visualbell
set expandtab	"use spaces, not tabs (use Ctrl-V+Tab to insert a tab)
set ruler		"show line info at bottom
set hlsearch
set linebreak   " wrap visual at word boundaries
set showbreak=>>
set showfulltag

syntax enable
if has("spell")
    "set spell   "check spelling (z= suggestions, zg add good word, zb bad)
    syntax spell notoplevel
endif

"set showmatch	"show matching bracket

" =-=-=-=-=
" Set up maps and abbreviations
" =-=-=-=-=
nmap <Tab> >>
nmap <S-Tab> <<
map \ :!<up><CR>
ounmap \
map \| :make<up><CR>
ounmap \|
map gs :%s/
vmap gs :s/
nmap ^ <C-^>
nmap <A-Left> :bp<CR>
nmap <A-Right> :bn<CR>
map <F5> :make 
nmap <BS> X

"
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

" =-=-=-=-=
" File settings
" =-=-=-=-=
" Show these file types at the end while using :edit command
set suffixes+=.class,.exe,.o,.obj,.dat,.dll,.aux,.pdf,.gch

" read tags 4 directories deep
set tags=./tags;../../../../

filetype plugin indent on

" =-=-=-=-=
" Set up colours
" =-=-=-=-=
"source ~/.vim/colours/carvedwood.vim
source $VIMRUNTIME/colors/elflord.vim

" =-=-=-=-=
" Import plugins
" =-=-=-=-=
"source $VIMRUNTIME/macros/matchit.vim
