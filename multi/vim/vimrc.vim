" Author:	DBriscoe (idbrii@gmail.com)
" Notes:
" Probably doesn't work well on old (<7.4) vim.
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

" Must occur before syntax/filetype on (which pathogen triggers).
set guioptions+=M			" Don't bother sourcing the menu

" Some things need to be setup before anything else in the vimrc (but after
" the above path setup since it uses those paths).
runtime before_vimrc.vim

" Storage {{{1
" I put most vim temp files in their own directory.
let g:david_cache_root = expand('$HOME/.vim-cache')
if exists("*mkdir")
    for folder in [g:david_cache_root, g:david_cache_root.'/temp']
        if filewritable(folder) == 0
            call mkdir(folder, "p", 0700)
        endif
    endfor
endif

" Auto-create directories for new files.
if exists("*mkdir")
    function! s:CreateDir()
        " Plugins like fugitive's diff won't use buftype=nofile/nowrite to
        " allow :write to apply. They probably use noswapfile or bufhidden.
        if &swapfile && len(&bufhidden) == 0
            call mkdir(expand('<afile>:p:h'), 'p')
        endif
    endf
    au BufWritePre,FileWritePre * silent! call s:CreateDir()
endif

if has('win32')
    if !filereadable(expand('~/.vim/bundle/vimproc/lib/vimproc_win64.dll'))
        " Failed to find built vimproc, so disable vimproc. You can find prebuilts
        " here:
        "   https://github.com/Shougo/vimproc.vim/releases
        let loaded_vimproc = 0
    endif
else
    " For now, don't use vimproc on any other platform
    let loaded_vimproc = 0
endif

" unite (fuzzy searcher) cache
let g:unite_data_directory = g:david_cache_root.'/unite'
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
set guioptions-=t			" Disable the tearoff menus (don't use 'em)
if has("win32")
    set guioptions-=e		" Disable fancy tabline (repositions vim on tab in Win32)
    set guioptions-=L		" Disable left scrollbar (repositions vim on vsplit in Win32)
endif

if !has("gui_running")
    if 0 < &t_Co && &t_Co <= 8
        if &t_Co == 8 && $TERM !~# '^linux'
            " sensible will actually bump t_Co up to 16. evening looks
            " terrible there, but desert is fine.
            colorscheme desert
        else
            " evening looks decent on low colours, but is hideous in 256-color and
            " in the gui. Only apply this if not linux
            colorscheme evening
        endif
    elseif &t_Co >= 256
        if system("uname -a") =~ "Microsoft"
            " This looks better for Bash on Windows. (Not sure why vim isn't
            " using the right colors.)
            colorscheme jellybeans
        else
            " looks good on my hi-color ubuntu terminal
            "colorscheme lucius
            " Try out apprentice since work went into making it work in
            " terminals.
            colorscheme apprentice
        endif
    elseif has("macunix")
        " looks good on my mac terminal
        colorscheme elflord
    elseif has("win32")
        " looks better than sandydune on Win command prompt
        colorscheme desert
    endif
endif

" Windowing (Full screen on my monitor)
command! VertScreen set lines=59
command! LargeScreen set lines=59 | set columns=100

" Undo {{{1
if has("persistent_undo")
    " Enable undo that lasts between sessions.
    " TODO: how/when to clean up undo files?
    set undofile
    let &undodir = g:david_cache_root.'/undo'
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
if v:version > 703
    set formatoptions+=j    " Delete comment character when joining commented lines
endif
set isfname-==              " allow completion in var=/some/path
set tabstop=4				" 1 tab = x spaces
set shiftwidth=4			" Used by auto indent (see below for 0)
set softtabstop=4           " &sw spaces as a tab for bs/del
if exists('&breakindent')
    " Show line wraps as lines with one additional indent.
    set breakindent
    set breakindentopt=shift:4
endif
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
set cinoptions+=#1          " Allow # to be a comment (Weird behavior when it's not. Fix in indent/cpp.vim)
set autoindent				" Indent like previous line
" Generally, 'smartindent' or 'cindent' should only be set manually if you're
" not satisfied with how file type based indentation works.
" Source: http://vim.wikia.com/wiki/Indenting_source_code#Methods_for_automatic_indentation
"set smartindent				" Try to be clever about indenting
"set cindent				" Really clever indenting

" Vim's built-in python indenting is excessive after open parens.
let g:pyindent_open_paren = '&sw'

if version > 600
    set backspace=start         " backspace can clear up to beginning of line
endif

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" We don't want to edit these type of files.
" But using .exe breaks vim-lsp. See vim-lsp/issues/685
set wildignore=*.o,*.obj,*.bak,*.pyc,*.swp
" Show these file types at the end while using :edit command
set suffixes+=.class,.exe,.o,.obj,.dat,.dll,.aux,.pdf,.gch

" Don't clobber my maps with Apple HIG movement.
let macvim_skip_cmd_opt_movement = 1
" I have my own. Don't waste time on macvim scheme.
let macvim_skip_colorscheme = 1

" Coding {{{1
set history=500				" cmdline history

" Figure out what function we're in. This relies on a coding standard where
" functions start in the first column (max_indents=0) and their signature is
" on one line.
" Mapped to the similar <C-g> (which I don't use very often).
"
" This is overridden in ftplugins with better versions for some languages.
" (Either changing the max_indents or completely new logic.)
" Consider combining this with <C-g>'s functionality (print both) and override
" that key? Would need cmdheight=2.
nnoremap <C-g><C-g> :<C-u>call david#search#FindScope(0)<CR>

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
    let can_autochdir = (!exists("v:vim_did_enter") || v:vim_did_enter) " Don't mess with vim on startup.
    let can_autochdir = can_autochdir && dirvish#can_autochdir() " Don't mess with dirvish
    let can_autochdir = can_autochdir && david#init#find_ft_match(['help', 'dirvish', 'qf']) < 0 " Not useful for some filetypes
    let can_autochdir = can_autochdir && filereadable(expand("%")) " Only change to real files.
    if can_autochdir
        silent! cd %:p:h
    endif
endf

if has("autocmd")
    augroup vimrcEx
        autocmd!

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
    " shellslash breaks some plugins because it changes slashes and quoting. (But
    " disabling it breaks other plugins and filepath completion (#1274).)
    " Using a unix-like shell ("C:\Windows\System32\bash.exe") could work (and
    " needs to be done with an environment variable to autoset other shell
    " variables), but breaks other things.
	let g:pydoc_allow_shellescape = 0
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
nnoremap <Leader><F1> :<C-u>sp ~/backlog.org<CR>
" I don't think agenda works, but set it anyway.
let g:org_agenda_files = ['~/backlog.org', '~/plan.org']

" Building {{{1

" Easy cmdline run
"nnoremap <Leader>\ :!<up><CR>

" Easy make
"nnoremap <Leader>\| :<C-u>make<up><CR>

" Using silent prevents possible output that requires hitting enter to clear
" every time I run make.
nnoremap <S-F5> :<C-u>silent make 
nnoremap <F5> :<C-u>make 
" IDE make. Setup with <filetype>SetEntrypoint commands.
nnoremap <Leader>im :<C-u>ProjectMake<CR>
nnoremap <Leader>ir :<C-u>ProjectRun<CR>

" If available, use scons instead of make. -u is upward search for root
" SConstruct.
if executable('scons')
    set makeprg=scons\ -u
endif

" Simple evaluator. Would be better to integrate with Ripple (so python and
" other built-in languages will maintain state), but this is a good hack for
" now. Strips the % in case that exists since we want it to process input.
" Works for python, not sure if it works for much else.
command! -range=% Eval execute '<line1>,<line2>:!'. substitute(&makeprg, '%', '', '')

" Tags {{{1

" read tags 4 directories deep
"set tags=./tags;../../../../
" search up recursively for tags file (to root)
set tags=./tags;/

" Don't show full path. Just give some path.
set cscopepathcomp=3

" Cscope equivalent of :tag
command! -nargs=1 Ctag cscope find g <args>

" Open preview window for tags (just jump with <C-]>)
nnoremap <A-]> :<C-u>ptag <C-r><C-w><CR>

" Simplify most common cscope command
" (<C-\>s is defined in cscope_maps.vim)
nmap <C-\><C-\> <C-\>s

" AsyncCommand
command! -nargs=1 Cscope AsyncCscopeFindSymbol <args>
let g:asynccommand_statusline_autohide = 1


" AsyncRun
let g:asyncrun_open = 3

" Provide a :Make so fugitive will use asyncrun.
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

augroup david-asyncrun
    au!
    au User AsyncRunStop call david#window#copen_without_moving_cursor()
augroup END

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

" <Shift-space> reloads the file using actual and simplified filename.
nnoremap <S-space> :<C-u>e <C-r>=resolve(expand('%:p'))<CR><CR>

" Folding {{{1

" Settings
" On vim 7.4, foldmethod=syntax makes ins-completion slow (see :h todo). Use
" indent by default. In zpersonalized.vim we can turn on syntax if fastfold
" has loaded.
set foldmethod=indent
set foldlevelstart=99		" All folds open by default

" At deepest, fold blocks within class methods
let g:david_foldnestmax = 3 " Standard value, used in ftplugins
let &foldnestmax = g:david_foldnestmax

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
vnoremap if :<C-u>silent!normal![zjV]zk<CR>
onoremap if :normal Vif<CR>
vnoremap af :<C-u>silent!normal![zV]z<CR>
onoremap af :normal Vaf<CR>

"""""""""""
" Plugins   {{{1

" Built-in   {{{2
" Disable some built-in plugins.
" I don't use these methods of installing vim plugins.
let g:loaded_getscriptPlugin = 0
let g:loaded_vimballPlugin = 0
" LogiPat seems useful, but I've never touched it.
let g:loaded_logiPat = 0

" lastplace   {{{2
let g:lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit,dirvish"

" LargeFile   {{{2
" Rumours that largefile sometimes causes changes in cursor position and undo
" loss: https://www.reddit.com/r/vim/comments/as0w1p/has_anyone_ran_into_the_problem_of_vim_losing/egqy00p/
let g:loaded_LargeFile = 0

" Magic make   {{{2
" Disable magic make since I'm not using a lot of makefiles these days.
" TODO: Setup scons files instead.
let b:loaded_magic_make = 1

" Renamer   {{{2
let g:RenamerSupportColonWToRename = 1

" matchup {{{2
" I find replacing statusline with match line distracting and confusing.
let g:matchup_matchparen_status_offscreen = 0

" Defer to improve cursor movement performance.
if has('timers')
    let g:matchup_matchparen_deferred = 1
    let g:matchup_matchparen_deferred_show_delay = 150
    let g:matchup_matchparen_deferred_fade_delay = 500
endif


" Ultisnips   {{{2
" Snippets -- Simplify commands. I rarely Expand. Instead I usually list and
" then complete.
let g:UltiSnipsExpandTrigger       = '<C-j>'
" Use unite instead of built-in list. See unite-david.
let g:UltiSnipsListSnippets        = ''
let g:UltiSnipsJumpForwardTrigger  = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
" Don't want undocumented and duplicate snippets from vim-snippets
let g:UltiSnipsEnableSnipMate = 0

let g:UltiSnipsSnippetsDir = '~/.vim/bundle/david-snippets/UltiSnips/'

" Omnicppcomplete   {{{2
"
" This is slow and doesn't work.
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_MayCompleteScope = 1

" OmniSharp   {{{2
"
" Either use the autoinstaller or define g:OmniSharp_server_path in local.vim
" as the path to extracted omnisharp.http-win-x64.zip from
" https://github.com/OmniSharp/omnisharp-roslyn/releases Must get http
" variant!
"
let g:OmniSharp_selector_ui = 'unite'
"~ let g:OmniSharp_typeLookupInPreview = 1

" Surround   {{{2
" Use c as my surround character (it looks like a hug)
" TEST: Try using s instead of c. See how it works. c is more useful in
" general, so I should get use to using it consistently.
xmap s <Plug>VSurround
xmap S <Plug>VSurround
" Use s so I don't have to use ys. This is weird since I use c in visual
" mode, but it doesn't make sense to change c in normal since it's more
" useful than c. Also other stuff is added to the end of it.
nmap s <Plug>Ysurround
nmap S <Plug>YSurround

" \ surrounds with anything. (Replaces latex map that I don't use except by
" accident.)
let g:surround_92 = "\1Surround with: \1 \r \1\1"

function! s:SetupSurroundForCurrentFiletype()
    " m surrounds with commented foldmarkers
    let comment = &commentstring
    " Escape % since they're interpreted by printf (tex, markdown use them in
    " commentstring).
    let comment = substitute(comment, '%', '%%', 'g')
    " Revert our %s target back.
    let comment = substitute(comment, '%%s', '%s', 'g')
    if len(comment) == 0
        let comment = "%s"
    endif
    let b:surround_109 = printf(comment, " \1Marker name: \1 {{{") . " \r " . printf(comment, " }}}")
endf
augroup SurroundCustom
    au!
    au FileType * call s:SetupSurroundForCurrentFiletype()
augroup END

" Cpp   {{{2
" Don't want menus for cpp.
let no_plugin_menus = 1
let c_no_curly_error = 1

" Lua   {{{2
" Only want luarefvim for its doc files.
let loaded_luarefvim = 0

" Ropevim   {{{2
" Don't use <C-c> mappings -- I don't use the maps much.
let g:ropevim_enable_shortcuts = 0
let g:ropevim_local_prefix = '<LocalLeader>r'
let g:ropevim_global_prefix = '<LocalLeader>r'

" Eclim   {{{2
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

" Xml   {{{2
" Reduce the amount of automatic stuff from xml.vim
let g:no_xml_maps = 1

" Pydoc   {{{2
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
" Let !python and :py output utf-8.
let $PYTHONIOENCODING = "utf-8"

" Calendar   {{{2
let g:calendar_no_mappings = 1

" Scratch   {{{2
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

" NotGrep/searchsavvy   {{{2
let g:notgrep_no_mappings = 1

if executable('rg')
    let g:searchsavvy_smartgrep_auto_enable = 0
    let &grepprg = 'rg --vimgrep'
    let &grepformat = "%f:%l:%c:%m"
    call notgrep#setup#NotGrepUseRipgrep()
else
    " Fallback to grep so NotGrepRecursiveFrom will work.
    let g:notgrep_prg = &grepprg
    let g:notgrep_efm = &grepformat
endif


" EasyAlign   {{{2
" Not sure if alignment is used often enough to get Enter key. Try it for now.
" Use Enter as a map and Space+Enter for live align mode. Maps default to
" align all delimiters because anything else is surprising.
xmap <Enter> <Plug>(LiveEasyAlign)*
xmap <Leader><Enter> <Plug>(LiveEasyAlign)
" Enter is commonly mapped in plugin windows (like quickfix), so prefix with
" leader. This is an operator, so it doesn't default to all delimiters (*).
nmap <Leader><Enter> <Plug>(LiveEasyAlign)

" Make it easier to align tags
let g:easy_align_delimiters = {
            \   '<': {
            \       'pattern': '<',
            \       'left_margin':  1,
            \       'right_margin': 0,
            \   }
            \ }


" Provide a / delimiter for the current filetype's comment marker.
augroup easyalign_david
    au!
    au BufEnter * let g:easy_align_delimiters['/'] = { 'pattern': substitute(&commentstring, '%s.*', '', ''), 'ignore_groups': ['!Comment'] }
augroup END

" context   {{{2
" I don't like extra mappings
let g:context_add_mappings = 0
" Disable by default and use mapping to access.
let g:context_enabled = 0
nnoremap <silent> <Leader>ic :<C-u>ContextToggle<CR>:echo g:context.enabled ? "with context" : "no context"<CR>

" Slime   {{{2
if !executable('screen') && !executable('tmux')
    let g:loaded_slime = 0
endif
let g:slime_no_mappings = 1

" Thesaurus   {{{2
let g:tq_map_keys = 0
" Use the same keys as thesaurus completion. Doesn't actually complete words
" in insert mode.
inoremap <silent> <C-x><C-t> <C-o>:ThesaurusQueryReplaceCurrentWord<CR>
vnoremap <silent> <C-x><C-t> "cy:<C-u>ThesaurusQueryReplace <C-r>c<CR>
nnoremap <silent> <C-x><C-t> :<C-u>ThesaurusQueryReplaceCurrentWord<CR>

" table-mode
" Disable maps that conflict with standard vim { and } commands
let g:table_mode_motion_up_map = ''
let g:table_mode_motion_down_map = ''

" DetectIndent should use my settings when it doesn't know what to do.
let g:detectindent_preferred_when_mixed = 1
let g:detectindent_preferred_expandtab = &expandtab
" Zero indent means don't modify (keep it at filetype setting).
let g:detectindent_preferred_indent = 0

" expand-region
" I'm not sure that normal map is very useful since it always select a word.
" But I'm also not sure of a reasonable use for that map.
xmap iv <Plug>(expand_region_expand)
xmap iV <Plug>(expand_region_shrink)

" polyglot   {{{2
let g:polyglot_disabled = get(g:, 'polyglot_disabled', [])
" I have two different python syntax plugins. Prefer mine over polyglot's.
call add(g:polyglot_disabled, 'python')

"}}}



" =-=-=-=-=-=
" Source local environment additions
runtime local.vim

" vim:set et sw=4 ts=4 fdm=marker fmr={{{,}}}:
