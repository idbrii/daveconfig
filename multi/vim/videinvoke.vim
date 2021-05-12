" Settings for when vim is invoked from an IDE.
"
" Be sure to call cursor() before :runtime, or you won't consistently jump to
" the line.
"
" VS passes the following arguments to vim:
"   --servername Vide --remote-silent +"call cursor($(CurLine),$(CurCol))" +"runtime videinvoke.vim" $(ItemPath)
"   It might be useful to include: +"set path+=$(SolutionDir)/**"
" Eclipse passes:
"   --servername Vide --remote-silent "+runtime videinvoke.vim" "+set path+=${project_loc}/**" ${resource_loc}
" Unity passes nothing on Mac and on Win:
"   --servername Vide --remote-silent +"call cursor($(Line),$(Column))" +"runtime videinvoke.vim" +"set path+=$(ProjectPath)/**" $(File)
"   (Mac programs calling a .app have their own protocol for passing line
"   numbers. So configure them to pass nothing.)
" Monodevelop uses:
"   --servername Vide --remote-silent +"call cursor(${CurLine},${CurColumn}) | runtime videinvoke.vim | set path+=${SolutionDir}/**" ${FilePath} 
" Godot uses:
"   vide.cmd "+call cursor({line},{col})" "+runtime videinvoke.vim" "+set path+={project}/**" {file}


" videinvoke is intended to be used from external programs, so we probably
" don't have focus. Take it.
call foreground()

if !exists('loaded_videinvoke')
	" Faster way to open. Should I make this symmetrical with the ide's map?
	nnoremap <Leader>ii :<C-u>VSOpen<CR>

    call david#window#layout_restore()
    call david#window#layout_save_on_exit()

    " If default or smaller screen size then make it bigger
    if &columns<=80 && &lines<=24
        " Decent width
        set columns=100
        " Full screen height
        set lines=9999
    endif

    " On small screens maximize is good, but on big monitors it's pointless.
    "~ if has("win32")
    "~     " Maximize
    "~     simalt ~x
    "~ endif

	" Quarter screen for preview window.
	let &previewheight = &lines / 4

    let g:asyncrun_open = max([3, &lines / 10])

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
" anything that wants the cwd works better.
cd %:p:h
