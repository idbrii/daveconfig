" Author:	DBriscoe (pydave@gmail.com)
" Influences:
"	* MacVim's defaults: http://macvim.org/OSX/index.php
" Notes:
" mapping Tab in normal mode breaks cscope -- adds tabs when you jump somewhere

" Initial setup {{{1
set nocompatible				" who needs vi, we've got Vim!

" Don't load plugins if we aren't in Vim7
if version < 700
	set noloadplugins
endif

" On Windows, also use '.vim' instead of 'vimfiles'; this makes
" synchronization across (heterogeneous) systems easier.
if has('win32')
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

" Some things need to be setup before anything else in the vimrc (but after
" the above path setup since it uses those paths).
runtime before_vimrc.vim

" Storage {{{1
" I put most vim temp files in their own directory.
let s:vim_cache = expand('$HOME/.vim-cache')
if filewritable(s:vim_cache) == 0 && exists("*mkdir")
    call mkdir(s:vim_cache, "p", 0700)
endif

" ctrlp (fuzzy file finder) cache
let g:ctrlp_cache_dir = s:vim_cache.'/ctrlp'

" Default to utf-8 instead of latin1
if !exists('$LANG')
    set encoding=utf-8
endif

" Display {{{1
set background=dark			" I use dark background
set nolazyredraw				" Don't repaint when scripts are running
set scrolloff=3				" Keep 3 lines below and above cursor
"set number					" Show line numbering
"set numberwidth=1			" Use 1 col + 1 space for numbers
set guioptions-=T			" Disable the toolbar

if !has("gui_running")
    if 0 < &t_Co && &t_Co <= 8
        " evening looks decent on low colours, but is hideous in 256-color and
        " in the gui.
        colorscheme evening
    elseif &t_Co >= 256
        " looks good on my hi-color ubuntu terminal
        colorscheme lucius
    elseif has("macunix")
        " looks good on my mac terminal
        colorscheme elflord
    elseif has("win32")
        " looks better than sandydune on Win command prompt
        colorscheme desert
    endif
endif

" Undo {{{1
if has("persistent_undo")
    " Enable undo that lasts between sessions.
    " TODO: how/when to clean up undo files?
    set undofile
    let &undodir = s:vim_cache.'/undo'
    if filewritable(&undodir) == 0 && exists("*mkdir")
        " If the directory doesn't exist try to create undo dir, because vim
        " 703 doesn't do it even though this change should make it work:
        "   http://code.google.com/p/vim-undo-persistence/source/detail?r=70
        call mkdir(&undodir, "p", 0700)
    endif

    augroup persistent_undo
        au!
        au BufWritePre /tmp/*           setlocal noundofile
        au BufWritePre COMMIT_EDITMSG   setlocal noundofile
        au BufWritePre *.tmp            setlocal noundofile
        au BufWritePre *.bak            setlocal noundofile
        au BufWritePre .vim-aside       setlocal noundofile
    augroup END
endif

" Settings {{{1

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

""" Buffers
"set splitbelow                  " Make preview (and all other) splits appear at the bottom
set switchbuf=useopen       " Ignore tabs; try to stay within the current viewport

"""" Editing
set nojoinspaces            " I don't use double spaces
set showmatch				" Briefly jump to the matching bracket
set matchtime=1				" For .1 seconds
"set formatoptions-=tc		" can I format for myself?? (only matters when textwidth>0)
set formatoptions+=r		" magically continue comments
set formatoptions-=o        " I tend to use o for whitespace, not continuing
                            " comments (some filetypes overwrite)
set isfname-==              " allow completion in var=/some/path
set tabstop=4				" 1 tab = x spaces
set shiftwidth=4			" (used on auto indent)
set softtabstop=4			" 4 spaces as a tab for bs/del
set smarttab				" Use tab button for tabs
set expandtab				" Use spaces, not tabs (use Ctrl-V+Tab to insert a tab)
set cinkeys-=0#             " Free # from the first column: It's for more than preprocessors!
"set autoindent				" Indent like previous line
set smartindent				" Try to be clever about indenting
"set cindent				" Really clever indenting
if version > 600
    set backspace=start         " backspace can clear up to beginning of line
endif

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" we don't want to edit these type of files
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.swp
" Show these file types at the end while using :edit command
set suffixes+=.class,.exe,.o,.obj,.dat,.dll,.aux,.pdf,.gch

" Coding {{{1
set history=500				" 100 Lines of history

" Figure out what function we're in. This relies on a coding standard where
" functions start in the first column and their signature is on one line.
" Mapped to the similar <C-g> (which I don't use very often).
" TODO: Should this be language-specific? There's definitely a better version
" for python (to allow nested definitions and to show functions and classes.
" Can I combine this with <C-g>'s functionality (print both) and override that
" key?
nnoremap <C-g><C-g>  :let last_search=@/<Bar> ?^\w? mark c<Bar> noh<Bar> echo getline("'c")<Bar> let @/ = last_search<CR>


" Command Line {{{1
" Autocomplete in cmdline: Give longest completion with list of options then
" tab through options.
set wildmenu
set wildmode=longest:list,full

" Autocommands {{{1
if has("autocmd")
augroup vimrcEx
au!
	" In plain-text files and svn commit buffers, wrap automatically at 78 chars
"	au FileType text,svn setlocal tw=78 fo+=t

	" In most files, jump back to the last spot cursor was in before exiting
    " (except: git commit)
    " See :help last-position-jump
	au BufReadPost * if &ft != 'gitcommit' |
		\ if line("'\"") > 1 && line("'\"") <= line("$") |
		\   exe "normal g`\"" |
		\ endif

    " Commenting blocks
    autocmd FileType build,xml,html xnoremap <buffer> <C-o> <ESC>'<O<!--<ESC>'>o--><ESC>
    autocmd FileType java,c,cpp,cs  xnoremap <buffer> <C-o> <ESC>'<O/*<ESC>'>o*/<ESC>

	" Switch to the directory of the current file, unless it's a help file.
    " Could use BufEnter instead, but then we have constant changing pwd.
    " Use <S-space> to reload the buffer if you want to cd.
	au BufReadPost * if &ft != 'help' | silent! cd %:p:h | endif

    " Disabled: I use the preview window for more than just omnicompletion, so
    " maybe killing it so easily doesn't make sense.
	" kill calltip window if we leave insert mode
	"au InsertLeave * if pumvisible() == 0|silent! pclose|endif

	augroup END
endif

" Completion {{{1

" bind ctrl+space for omnicompletion
inoremap <C-Space> <C-x><C-o>

" Use all complete options
set completeopt=menu,preview,menuone
" Note: we must choose between showfulltag and completeopt+=longest. See help.
"set showfulltag				" Show more information while completing tags
set completeopt+=longest        " Fill in the longest match

" Don't search included files for insert completion since that should be fast. 
" Don't use tags for insert completion, that's what omnicomplete is for
set complete-=t
set complete-=i

" Always use forward slashes.
if exists('+shellslash')
    set shellslash
endif

" Asides {{{1

" Write Asides to yourself. (Quick access to a file for random things I want
" to write down.)
nnoremap <F1> :sp ~/.vim-aside<CR>
nnoremap <S-F1> :e ~/.vim-aside<CR>

" Similar map for todo.
nnoremap <Leader><F1> :sp ~/.todo.org<CR>

" Building {{{1

" Easy cmdline run
"nnoremap <Leader>\ :!<up><CR>

" Easy make
"nnoremap <Leader>\| :make<up><CR>

" Using silent prevents possible output that requires hitting enter to clear
" every time I run make.
nnoremap <S-F5> :silent make 
nnoremap <F5> :make 

" If available, use scons instead of make. -u is upward search for root
" SConstruct.
if executable('scons')
    set makeprg=scons\ -u
endif

" Tags {{{1

" read tags 4 directories deep
"set tags=./tags;../../../../
" search up recursively for tags file (to root)
set tags=./tags;/

" Don't show full path. Just give some path.
set cscopepathcomp=3

" Toggle the tag list bar
nnoremap <F4> :TlistToggle<CR>

" Open preview window for tags (just jump with <C-]>)
nnoremap <A-]> :ptag <C-r><C-w><CR>

" Simplify most common cscope command
" (<C-\>s is defined in cscope_maps.vim)
nmap <C-\><C-\> <C-\>s

" AsyncCommand
cabbrev Cscope AsyncCscopeFindSymbol
let g:asynccommand_statusline_autohide = 1

" Common text {{{1

nnoremap <C-s> :w<CR>

" Underscores are like visible spaces. So the alt version of space is
" underscore.
" TODO: I don't know if this works in ubuntu.
inoremap <A-Space> _
cnoremap <A-Space> _

" change increment to allow select all
nnoremap <C-x><C-s> <C-a>
nnoremap <C-x><C-x> <C-x>
" Don't let speeddating override the above. (They'll be properly mapped later
" if speeddating loads.)
let g:speeddating_no_mappings = 1

" select all
nnoremap <C-a> 1GVG

" gc selects previously changed text. (|gv| but for modification.)
nnoremap gc :<C-U>silent!normal!`[v`]<CR>
xnoremap gc :<C-U>silent!normal!`[v`]<CR>

" Make backspace work in normal
nnoremap <BS> X

" Make cw consistent with dw?
"nnoremap cw dwi

" undo a change in the previous window - often used for diff
nnoremap <C-w>u :wincmd p <bar> undo <bar> wincmd p <bar> diffupdate<CR>
" Faster diff update.
function! s:UpdateDiff()
    if &diff
        diffupdate
    else
        echom "E99: Current buffer is not in diff mode"
    endif
endf
nnoremap <silent> du :call <SID>UpdateDiff()<CR>

" Generic Header comments (requires formatoptions+=r)
"  Uses vim's commentstring to figure out the local comment character
nnoremap <Leader>hc ggO<C-r>=&commentstring<CR><Esc>0/%s<CR>2cl<CR> <C-r>%<CR><CR>Copyright (c) <C-R>=strftime("%Y")<CR> _company All Rights Reserved.<CR><Esc>3kA

" Indent {{{2
" Use Ctrl-Tab/Tab and Shift-Tab to change indent in visual
" Note: this can probably be done with Select mode, but I don't use that.
xnoremap <C-Tab> >gv
xnoremap <Tab> >gv
xnoremap <S-Tab> <LT>gv
" Use ctrl-tab and shift-tab for indent in normal mode
nnoremap <C-Tab> >>
nnoremap <S-Tab> <<
" and insert mode
inoremap <C-Tab> <C-t>
inoremap <C-S-Tab> <C-d>

" Shadow: Improve existing commands {{{2

" Use CTRL-G u to break undo for some insert commands.
" CTRL-U in insert mode deletes a lot. Break to undo CTRL-U without undoing
" what you typed before it.
inoremap <C-U> <C-G>u<C-U>
" Break to make each line undoable.
inoremap <CR> <C-G>u<CR>

" CTRL-g shows filename and buffer number, too.
nnoremap <C-g> 2<C-g>

" Q formats paragraphs, instead of entering ex mode
noremap Q gq

" <Shift-space> reloads the file
nnoremap <S-space> :e<CR>

" Folding {{{1

" Settings
set foldmethod=syntax		" By default, use syntax to determine folds
set foldlevelstart=99		" All folds open by default
set foldnestmax=3           " At deepest, fold blocks within class methods

" <space> toggles folds opened and closed
nnoremap <Space> za
nnoremap <Leader><Space> zA

" <space> in visual mode creates a fold over the marked range
"xnoremap <space> zf

" From Paradigm: http://www.reddit.com/r/vim/comments/10cqgd/looking_for_a_languageaware_block_selection/c6cpyrg
" enable syntax folding for a variety of languages
"set g:vimsyn_folding = 'afmpPrt'
" create text object using [z and ]z
vnoremap if :<C-U>silent!normal![zjV]zk<CR>
onoremap if :normal Vif<CR>
vnoremap af :<C-U>silent!normal![zV]z<CR>
onoremap af :normal Vaf<CR>

" Create text objects for pairs of identical characters
for char in [ '$', '%', '*', ',', '-', '_', '.', '/', ':', ';', '<bar>', '<bslash>', '=' ]
	exec 'xnoremap i' . char . ' :<C-U>silent!normal!T' . char . 'vt' . char . '<CR>'
	exec 'onoremap i' . char . ' :normal vi' . char . '<CR>'
	exec 'xnoremap a' . char . ' :<C-U>silent!normal!F' . char . 'vf' . char . '<CR>'
	exec 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor

"""""""""""
" Abbreviations   {{{1
"" Command

" Windowing (Full screen on my monitor)
command! VertScreen set lines=59
command! LargeScreen set lines=59 | set columns=100

" VimShell - run sh from within a Vim buffer
command! VShell runtime scripts/vimsh/vimsh.vim

"" Insert
" General
iabbrev _me DBriscoe (pydave@gmail.com)
iabbrev _company pydave

" Shebangs
iabbrev shebangpy #! /usr/bin/env python
iabbrev shebangsh #! /bin/sh
iabbrev shebangbash #! /bin/bash

" constructs
iabbrev frepeat for (int i = 0; i < 0; ++i)

"}}}
" Plugins   {{{1

" Magic make
" Disable magic make since I'm not using a lot of makefiles these days.
" TODO: Setup scons files instead.
let b:loaded_magic_make = 1

" Renamer
let g:RenamerSupportColonWToRename = 1

" Snippets -- Simplify commands. I rarely Expand. Instead I usually list and
" then complete.
let g:UltiSnipsExpandTrigger       = '<C-j>'
let g:UltiSnipsListSnippets        = '<C-r><C-j>'
let g:UltiSnipsJumpForwardTrigger  = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'


" Gundo -- visualize the undo tree
nnoremap <F2> :GundoToggle<CR>

" Surround
" Use c as my surround character (it looks like a hug)
xmap c <Plug>VSurround
xmap C <Plug>VSurround

" \ surrounds with anything. (Replaces latex map that I don't use except by
" accident.)
let g:surround_92 = "\1Surround with: \1 \r \1\1"

function! s:SetupSurroundForCurrentFiletype()
    " m surrounds with commented foldmarkers
    " Ensure we escape %%s which printf doesn't recognize as %s.
    let comment = substitute(&commentstring, '%%s', '%%%s', 'g')
    let b:surround_109 = printf(comment, " \1Marker name: \1 {{{") . " \r " . printf(comment, " }}}")
endf
augroup SurroundCustom
    au!
    au FileType * call s:SetupSurroundForCurrentFiletype()
augroup END

" Cpp
" Don't want menus for cpp.
let no_plugin_menus = 1

" Ropevim
" Don't use <C-c> mappings -- I don't use the maps much.
let g:ropevim_enable_shortcuts = 0
let g:ropevim_local_prefix = '<LocalLeader>r'
let g:ropevim_global_prefix = '<LocalLeader>r'

" SuperTab
"let g:SuperTabDefaultCompletionType = 'context'
"let g:SuperTabMappingForward = '<c-space>'
"let g:SuperTabMappingBackward = '<s-c-space>'
" supertab + eclim == java win
"let g:SuperTabDefaultCompletionTypeDiscovery = [
"            \ "&completefunc:<c-x><c-u>",
"            \ "&omnifunc:<c-x><c-o>",
"            \ ]
"let g:SuperTabLongestHighlight = 1
"let g:SuperTabMappingTabLiteral = '<tab>'

" Eclim was trying to connect on startup because it sees loaded_taglist
" Either one of these flags to fixed it, but now it doesn't happen anymore.
"let g:EclimTaglistEnabled = 0
"let g:taglisttoo_disabled = 1

" Eclim indentation makes the screen flicker and doesn't help much
let g:EclimXmlIndentDisabled = 1
" Eclim xml validation never works because I don't have DTDs
let g:EclimXmlValidate = 0

" Note: To turn off the signs that are added everywhere, you can use these
" commands:
" sign undefine qf_warning
" sign undefine qf_error

" Don't show todo markers in margin
let g:EclimSignLevel = 2

" Reduce the amount of automatic stuff from xml.vim
let g:no_xml_maps = 1

" Don't have maps for bufkill -- too easy to delete a buffer by accident
let no_bufkill_maps = 1


" Pydoc
"  Pydoc maps conflict with \p
let no_pydoc_maps = 1
"  Highlighting is ugly
let g:pydoc_highlight = 0

" Turning all on gives me end of line highlighting that I don't like.
" For some reason, if I turn everything else on, then I don't get it.
"let python_highlight_all = 1
let python_highlight_builtin_funcs = 1
let python_highlight_builtin_objs = 1
let python_highlight_doctests = 1
let python_highlight_exceptions = 1
let python_highlight_indent_errors = 1
let python_highlight_space_errors = 1
let python_highlight_string_format = 1
let python_highlight_string_formatting = 1
let python_highlight_string_templates = 1

" Calendar
let g:calendar_no_mappings = 1

" Scratch
let g:itchy_always_split = 1
"issue #1: let g:itchy_startup = 1

" Quick access to a Scratch and a Scratch of the current filetype
nnoremap <Leader>ss :Scratch<CR>
nnoremap <Leader>sf :exec 'Scratch '. &filetype<CR>

" Golden-ratio
" Don't resize automatically.
let g:golden_ratio_autocommand = 0

" Mnemonic: - is next to =, but instead of resizing equally, all windows are
" resized to focus on the current.
nmap <C-w>- <Plug>(golden_ratio_resize)
" Fill screen with current window.
nnoremap <C-w>+ <C-w><Bar><C-w>_

" Powerline
" Don't want to need patched fonts everywhere.
let Powerline_symbols = 'compatible'
let Powerline_stl_path_style = 'relative'
" Use my theme
let Powerline_theme = 'sanity'
let Powerline_colorscheme = 'sanity'

let g:Powerline#Segments#ctrlp#segments#focus = ''
let g:Powerline#Segments#ctrlp#segments#prev = ''
let g:Powerline#Segments#ctrlp#segments#next = ''

" NotGrep
let g:notgrep_no_mappings = 1

" Operators
map <Leader>` <Plug>(operator-camelize-toggle)

"}}}



" =-=-=-=-=-=
" Source local environment additions
runtime local.vim

" vi: et sw=4 ts=4 fdm=marker fmr={{{,}}}
