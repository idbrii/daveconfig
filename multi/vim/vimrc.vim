" Author:	DBriscoe (idbrii@gmail.com)
" Influences:
"	* MacVim's defaults: http://macvim.org/OSX/index.php
" Notes:
" mapping Tab in normal mode breaks cscope -- adds tabs when you jump somewhere

" Initial setup {{{1

" Don't load plugins if we aren't in Vim7
if v:version < 700
	set noloadplugins
endif

" On Windows, also use '.vim' instead of 'vimfiles'; this makes
" synchronization across (heterogeneous) systems easier.
if has('win32')
    set runtimepath^=$HOME/.vim
    set runtimepath+=$HOME/.vim/after
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
" unite (fuzzy searcher) cache
let g:unite_data_directory = s:vim_cache.'/unite'
" unite-mru cache
let g:neomru#file_mru_path = g:unite_data_directory .'/neomru/file'

" Move viminfo into cache directory
set viminfo+=n~/.vim-cache/viminfo
if has("autocmd")
    autocmd BufRead,BufNewFile */.vim-cache/viminfo set filetype=viminfo
endif

" Default to utf-8 instead of latin1
if !exists('$LANG')
    set encoding=utf-8
endif

if has('win32')
	let g:snips_author = expand('$USERNAME')
else
	let g:snips_author = expand('$USER')
endif

" Writing files on Windows doesn't preserve file attributes seen via cygwin
" (presumably because the created backup copy didn't inherit them correctly).
if has('win32') && v:version < 704
    set backupcopy=yes
endif

" Prefer unix on all platforms.
" This essentially makes Windows and Mac use defaults like Unix. Combined with
" git's core.autocrlf=input prevents line ending issues on Windows. Probably
" works better on mac too.
if has('win32') || has("macunix")
    " Remove unix to ensure when we prepend it is added at the beginning.
    set fileformats-=unix
    set fileformats^=unix
endif

" Display {{{1
set background=dark			" I use dark background
set nolazyredraw				" Don't repaint when scripts are running
set scrolloff=3				" Keep 3 lines below and above cursor
"set number					" Show line numbering
"set numberwidth=1			" Use 1 col + 1 space for numbers
set guioptions-=T			" Disable the toolbar
set guioptions-=m			" Disable the menu
set guioptions+=M			" Don't bother sourcing the menu
set guioptions-=t			" Disable the tearoff menus (don't use 'em)
if has("win32")
    set guioptions-=e		" Disable fancy tabline (repositions vim on tab in Win32)
    set guioptions-=L		" Disable left scrollbar (repositions vim on vsplit in Win32)
endif

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
set shiftwidth=4			" Used by auto indent (see below for 0)
set softtabstop=4           " &sw spaces as a tab for bs/del
if v:version >= 704
    " Zero keeps in sync with tabstop in Vim 7.4+, but it breaks indentation
    " (I think especially autoindent).
    " See: https://github.com/tpope/vim-sleuth/issues/25
    "set shiftwidth=0
    " Negative value automatically keeps in sync with shiftwidth in Vim 7.4+.
    set softtabstop=-1
endif
set smarttab				" Use tab button for tabs
set expandtab				" Use spaces, not tabs (use Ctrl-V+Tab to insert a tab)
set cinoptions+=#1          " Check if # is a comment
set autoindent				" Indent like previous line
" Generally, 'smartindent' or 'cindent' should only be set manually if you're
" not satisfied with how file type based indentation works.
" Source: http://vim.wikia.com/wiki/Indenting_source_code#Methods_for_automatic_indentation
"set smartindent				" Try to be clever about indenting
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
set history=500				" cmdline history

" Figure out what function we're in. This relies on a coding standard where
" functions start in the first column and their signature is on one line.
" Mapped to the similar <C-g> (which I don't use very often).
" TODO: Should this be language-specific? There's definitely a better version
" for python (to allow nested definitions and to show functions and classes.
" Can I combine this with <C-g>'s functionality (print both) and override that
" key?
nnoremap <C-g><C-g>  :<C-u>let last_search=@/<Bar> ?^\w? mark c<Bar> noh<Bar> echo getline("'c")<Bar> let @/ = last_search<CR>

" Command Line {{{1
" Autocomplete in cmdline: Give longest completion with list of options then
" tab through options.
set wildmenu
set wildmode=longest:list,full

" Autocommands {{{1

" 'autochdir' alternative so I can provide exceptions. See calling autocmd.
"
" Switch to the directory of the current file unless it breaks something.
function! s:autochdir()
    if v:vim_did_enter " Don't mess with vim on startup.
                \ && dirvish#can_autochdir() " Don't mess with dirvish
                \ && match(['help', 'dirvish'], printf("\<%s\>", &ft)) < 0 " Not useful for some filetypes
                \ && filereadable(expand("%")) " Only change to real files.
        silent! cd %:p:h
    endif
endf

if has("autocmd")
    augroup vimrcEx
        autocmd!
        " In most files, jump back to the last spot cursor was in before exiting
        " (except: git commit)
        " See :help last-position-jump
        autocmd BufReadPost * if &ft != 'gitcommit' |
                    \ if line("'\"") > 1 && line("'\"") <= line("$") |
                    \   exe "normal g`\"" |
                    \ endif

        " Commenting blocks
        " ~ prefix from https://www.reddit.com/r/vim/comments/4ootmz/what_is_your_little_known_secret_vim_shortcut_or/d4ehmql
        autocmd FileType build,xml,html xnoremap <buffer> <C-o> <ESC>'<O<!-- ~ <ESC>'>o--><ESC>
        autocmd FileType java,c,cpp,cs  xnoremap <buffer> <C-o> <ESC>'<O/*~ <ESC>'>o*/<ESC>

        " Could use BufEnter to be more like autochdir, but then we have constant changing pwd.
        " Use <S-space> to reload the buffer if you want to cd.
        autocmd BufReadPost * call s:autochdir()

        " Disabled: I use the preview window for more than just omnicompletion, so
        " maybe killing it so easily doesn't make sense.
        " kill calltip window if we leave insert mode
        "autocmd InsertLeave * if pumvisible() == 0|silent! pclose|endif

        " When invoking vim from bash with fc, use sh filetype.
        autocmd BufRead,BufNewFile /tmp/bash-fc-* set filetype=sh

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
nnoremap <F1> :<C-u>sp ~/.vim-aside<CR>
nnoremap <S-F1> :<C-u>e ~/.vim-aside<CR>

" My Kinesis keyboard has F1 where Esc used to be. I have no use for help in
" insert mode, so let's try this.
inoremap <F1> <Esc>

" Similar map for todo.
nnoremap <Leader><F1> :<C-u>sp ~/.todo.org<CR>

" Building {{{1

" Easy cmdline run
"nnoremap <Leader>\ :!<up><CR>

" Easy make
"nnoremap <Leader>\| :<C-u>make<up><CR>

" Using silent prevents possible output that requires hitting enter to clear
" every time I run make.
nnoremap <S-F5> :<C-u>silent make 
nnoremap <F5> :<C-u>make 

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

" Cscope equivalent of :tag
command! -nargs=1 Ctag cscope find g <args>

" Toggle the tag list bar
nnoremap <F4> :<C-u>TlistToggle<CR>

" Open preview window for tags (just jump with <C-]>)
nnoremap <A-]> :<C-u>ptag <C-r><C-w><CR>

" Simplify most common cscope command
" (<C-\>s is defined in cscope_maps.vim)
nmap <C-\><C-\> <C-\>s

" AsyncCommand
command! -nargs=1 Cscope AsyncCscopeFindSymbol <args>
let g:asynccommand_statusline_autohide = 1

" Common text {{{1

nnoremap <C-s> :<C-u>w<CR>
nnoremap <Leader>fs :<C-u>update<CR>

" Ignoring errors never seems like a good idea. I'd only hit this by accident.
" If I still want it, I could :w!
nnoremap ZQ <Nop>

" Underscores are like visible spaces. So the alt version of space is
" underscore.
" Does not work in ubuntu.
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

" Quick sort (haha)
xnoremap <Leader>s  <nop>
xnoremap <Leader>ss :sort<CR>
xnoremap <Leader>s; :sort 

" Use r for [right-angle braces] and a for <angle braces> like vim-surround
vnoremap ir i]
vnoremap ar a]
vnoremap ia i>
vnoremap aa a>
onoremap ir i]
onoremap ar a]
onoremap ia i>
onoremap aa a>

" gc selects previously changed text. (|gv| but for modification.)
nnoremap gc :<C-U>silent!normal!`[v`]<CR>
xnoremap gc :silent!normal!`[v`]<CR>

" Make backspace work in normal
nnoremap <BS> X

" Make cw consistent with dw?
"nnoremap cw dwi

" Generic Header comments (requires formatoptions+=r)
"  Uses vim's commentstring to figure out the local comment character.
nnoremap <Plug>(david-create-header-comment) ggO<C-r>=&commentstring<CR><Esc>0/%s<CR>2cl<CR> <C-r>=expand('%:t')<CR><CR><CR>Copyright <C-R>=strftime("%Y")<CR>, <C-r>=g:snips_company<CR><CR><C-u><Esc>o<Esc>3kA<CR>
nmap <Leader>hc <Plug>(david-create-header-comment)


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
" Make it easier to undo after putting from the wrong register.
inoremap <C-R> <C-G>u<C-R>

" CTRL-g shows filename and buffer number, too.
nnoremap <C-g> 2<C-g>

" Q formats paragraphs (without moving cursor), instead of entering ex mode
noremap Q gw

" <Shift-space> reloads the file
nnoremap <S-space> :<C-u>e<CR>

" Folding {{{1

" Settings
" On vim 7.4, foldmethod=syntax makes ins-completion slow (see :h todo). Use
" indent by default. In zpersonalized.vim we can turn on syntax if fastfold
" has loaded.
set foldmethod=indent
set foldlevelstart=99		" All folds open by default
set foldnestmax=3           " At deepest, fold blocks within class methods
let g:fastfold_map = 0

" <Leader>l toggles folds opened and closed
nnoremap <Leader>l za
nnoremap <Leader>L zA

" <Leader>l in visual mode creates a fold over the marked range
xnoremap <Leader>l zf

" From Paradigm: http://www.reddit.com/r/vim/comments/10cqgd/looking_for_a_languageaware_block_selection/c6cpyrg
" enable syntax folding for a variety of languages
"set g:vimsyn_folding = 'afmpPrt'
" create text object using [z and ]z
vnoremap if :silent!normal![zjV]zk<CR>
onoremap if :normal Vif<CR>
vnoremap af :silent!normal![zV]z<CR>
onoremap af :normal Vaf<CR>

let g:textobj_between_no_default_key_mappings = 1
xmap am  <Plug>(textobj-between-a)
omap am  <Plug>(textobj-between-a)
xmap im  <Plug>(textobj-between-i)
omap im  <Plug>(textobj-between-i)

" Use textobj-comment to select text in a comment (i/) and comment with
" delimeters and surrounding whitespace (a/). I'm not using comment with just
" delimeters.
let g:textobj_comment_no_default_key_mappings = 1
xmap i/  <Plug>(textobj-comment-i)
omap i/  <Plug>(textobj-comment-i)
xmap a/  <Plug>(textobj-comment-big-a)
omap a/  <Plug>(textobj-comment-big-a)

"""""""""""
" Abbreviations   {{{1
"" Command

" Windowing (Full screen on my monitor)
command! VertScreen set lines=59
command! LargeScreen set lines=59 | set columns=100

" VimShell - run sh from within a Vim buffer
command! VShell runtime scripts/vimsh/vimsh.vim

" Simple evaluator. Would be better to integrate with Ripple (so python and
" other built-in languages will maintain state), but this is a good hack for
" now. Strips the % in case that exists since we want it to process input.
" Works for python, not sure if it works for much else.
command! -range=% Eval execute '<line1>,<line2>:!'. substitute(&makeprg, '%', '', '')

"}}}
" Plugins   {{{1

" Disable some built-in plugins.
" I don't use these methods of installing vim plugins.
let g:loaded_getscriptPlugin = 0
let g:loaded_vimballPlugin = 0
" LogiPat seems useful, but I've never touched it.
let g:loaded_logiPat = 0

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

let g:UltiSnipsSnippetsDir = '~/.vim/bundle/david-snippets/UltiSnips/'

" Gundo -- visualize the undo tree
nnoremap <F2> :<C-u>GundoToggle<CR>

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
    if len(comment) == 0
        let comment = "%s"
    endif
    let b:surround_109 = printf(comment, " \1Marker name: \1 {{{") . " \r " . printf(comment, " }}}")
endf
augroup SurroundCustom
    au!
    au FileType * call s:SetupSurroundForCurrentFiletype()
augroup END

" Cpp
" Don't want menus for cpp.
let no_plugin_menus = 1
let c_no_curly_error = 1

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
let g:BufKillCreateMappings = 0

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

" Quick access to a Scratch and a Scratch of the current filetype
nmap <Leader>ss <Plug>(itchy-open-scratch)
nmap <Leader>sf <Plug>(itchy-open-same-filetype-scratch)

" Golden-ratio
" Don't resize automatically.
let g:golden_ratio_autocommand = 0

" Mnemonic: - is next to =, but instead of resizing equally, all windows are
" resized to focus on the current.
nmap <C-w>- <Plug>(golden_ratio_resize)
nmap <Leader>w- <Plug>(golden_ratio_resize)
" Fill screen with current window.
nnoremap <Plug>(window-fill-screen) <C-w><Bar><C-w>_
nmap <C-w>+ <Plug>(window-fill-screen)
nmap <Leader>w+ <Plug>(window-fill-screen)

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

" Only use editqf for modifying paths
let g:editqf_no_mappings = 1
let g:editqf_no_qf_mappings = 1
let g:editqf_no_type_mappings = 1
" editqf mapping is only applied in quickfix buffer.

" EasyAlign
" Not sure if alignment is used often enough to get Enter key. Try it for now.
" Use Enter as a quickmap for all (common use case) and C-Enter for normal
" align mode.
xmap <Enter> <Plug>(EasyAlign)*
xmap <Leader><Enter> <Plug>(EasyAlign)
" Enter is commonly mapped in plugin windows (like quickfix), so prefix with
" leader.
nmap <Leader><Enter> <Plug>(EasyAlign)

" Make it easier to align tags
let g:easy_align_delimiters = {
            \   '<': {
            \       'pattern': '<',
            \       'left_margin':  1,
            \       'right_margin': 0,
            \   }
            \ }

" Thesaurus
if executable("bash")
    let g:online_thesaurus_map_keys = 0
    " Use the same keys as thesaurus completion.
    nnoremap <unique> <C-x><C-t> :<C-u>OnlineThesaurusCurrentWord<CR>
else
    " The shell script doesn't work in Windows without bash (and cygwin).
    let g:loaded_online_thesaurus = -1
endif

" table-mode
" Disable maps that conflict with standard vim { and } commands
let g:table_mode_motion_up_map = ''
let g:table_mode_motion_down_map = ''

" DetectIndent isn't automatic, but it should use my settings when it doesn't
" know what to do.
let g:detectindent_preferred_when_mixed = 1
let g:detectindent_preferred_expandtab = &expandtab
" Zero indent means don't modify (keep it at filetype setting).
let g:detectindent_preferred_indent = 0

" Let's try always detecting indents.
augroup DetectIndent
    autocmd!
    autocmd BufReadPost * DetectIndent
augroup END

" expand-region
" I'm not sure that normal map is very useful since it always select a word.
" But I'm also not sure of a reasonable use for that map.
xmap iv <Plug>(expand_region_expand)
xmap iV <Plug>(expand_region_shrink)

"}}}



" =-=-=-=-=-=
" Source local environment additions
runtime local.vim

" vim:set et sw=4 ts=4 fdm=marker fmr={{{,}}}:
