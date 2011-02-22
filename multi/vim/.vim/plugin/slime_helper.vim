" Slime helper
" Uses slime.vim:
"   http://technotales.wordpress.com/2008/10/17/screencast-like-slime-for-vim/
" Gives you a list of slime sessions so you don't have to copy and paste the
" names
" Note: Clobbers c register
" Note: Must have name that comes after slime.vim so that this file is loaded
" second, otherwise mapping magic won't work.

" TODO: merge into slime.vim

function Slime_Auto_Screen_Vars()
    " Grab a list of screens
    redir @c
    silent ! screen -list
    redir END

    " Split output into lines
    let lines = split(@c, "\n")
    " Only grab lines with a pseudo-tty name
    call filter(lines, 'v:val =~ "pts"')

    if len(lines) > 1
        " Choose out of multiple screens
        let num = 0
        for line in lines
            " clean up nonprinting whitespace
            let line = substitute(line, "[	]", " ", "g")
            echomsg "  ". num .") ". line
            let num += 1
        endfor
        let selected_session = input("Connect to which screen?\n", "0")
    else
        let selected_session = 0
    endif
    let s:session_line = split(lines[selected_session])
    let s:session = s:session_line[0]
    let g:screen_sessionname = s:session

    " TODO: how to get list of windows?
    let g:screen_windowname = "0"

    if (! exists('no_plugin_maps') || ! no_plugin_maps)
        " Setup the map as defined in slime.vim
        nmap <Leader>r m`vip<Leader>r``
    endif

    echomsg "Using screen session ". g:screen_sessionname ." #". g:screen_windowname
endfunction

if (! exists('no_plugin_maps') || ! no_plugin_maps)
    " Map \r to call our function which will use the real the map for \r
    " This prevents \r from acting incorrectly when its first called
    nmap <Leader>r :call Slime_Auto_Screen_Vars()<CR>
endif
