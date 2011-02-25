" Slime helper
" Uses slime.vim:
"   http://technotales.wordpress.com/2008/10/17/screencast-like-slime-for-vim/
" Autoloads the first slime session if available
"
" Note: Must have name that comes after slime.vim so that this file is loaded
" second, otherwise mapping magic won't work.

" TODO: merge into slime.vim

function Slime_Auto_Screen_Vars()
    let sessions = split(Slime_Get_Screen_Session_Names(0,0,0), "\n")
    if len(sessions) == 1
        let b:slime = {"sessionname": sessions[0], "windowname": "0"}
    else
        call Slime_Screen_Vars()
    endif

    if (! exists('no_plugin_maps') || ! no_plugin_maps)
        " Setup the map as defined in slime.vim
        nmap <Leader>r m`vip<Leader>r``
    endif

    echomsg "Using screen session ". b:slime['sessionname'] ." #". b:slime['windowname']
endfunction

if (! exists('no_plugin_maps') || ! no_plugin_maps)
    " Map \r to call our function which will use the real the map for \r
    " This prevents \r from acting incorrectly when its first called
    nmap <Leader>r :call Slime_Auto_Screen_Vars()<CR>
endif
