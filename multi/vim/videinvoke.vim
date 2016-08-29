" Settings for when vim is invoked from an IDE.
"
" VS passes the following arguments to vim:
"   --servername Vide --remote-silent +"call cursor($(CurLine),$(CurCol))" +"runtime videinvoke.vim" $(ItemFileName)$(ItemExt)
" Eclipse passes:
"   --servername Vide --remote-silent "+runtime videinvoke.vim" "+set path+=${project_loc}/**" ${resource_loc}

" It might be useful to include: +"set path+=$(SolutionDir)/**" 

"According to this: http://vim.wikia.com/wiki/VimTip716
"<c-z> brings gvim to foreground - on win2k, gvim gets focus but won't bring
"itself to foreground otherwise. You can remove it if you don't have this
"bring-to-foreground problem.
" This doesn't work, but it calls foreground() which does something. Look into
" that and remote_foreground({server})

if !exists('loaded_videinvoke')
	" Faster way to open. Should I make this symmetrical with the ide's map?
	nnoremap <Leader>ii :<C-u>VSOpen<CR>

    " If default or smaller screen size then make it bigger
    if &columns<=80 && &lines<=24
        " Decent width
        set columns=100
        " Full screen height
        set lines=9999
    endif

    if has("win32")
        " Maximize
        simalt ~x
    endif

    " Use half of the resized screen height.
    let g:ctrlp_max_height = &lines / 2
	" Quarter screen for preview window.
	let &previewheight = &lines / 4


    """"" Load cscope and other tag databases if we can
    " Setup tag files for visual studio (game development)
	" disable verbose for our initial load
	set nocscopeverbose
	" add any database in current directory and all other tag files
	call LocateAll()
	" okay, be verbose from now on
	set cscopeverbose



    " Eclim:
    " Checking g:eclimd_running doesn't work, so see if an eclim command is
    " here.
    if exists(":EclimValidate") == 2
        EclimValidate
        source ~/.vim/plugin/eclim_menu.vim
        source ~/.vim/plugin/eclim_special.vim
    endif
endif
let loaded_videinvoke = 1


" Some settings are for the current file:

" Centre cursor
normal zz

" Keep up to date on change from external editor
setlocal autoread

" We'll be opened with the full path, but jump to the local directory so
" ctrlp, etc work better.
cd %:p:h
