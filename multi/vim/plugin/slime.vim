" Author: Jonathan Palardy
" Send buffer contents to a screen session
" http://technotales.wordpress.com/2008/10/17/screencast-like-slime-for-vim/
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function Send_to_Screen(text)
  if !exists("g:screen_sessionname") || !exists("g:screen_windowname")
    call Screen_Vars()
  end

  echo system("screen -S " . g:screen_sessionname . " -p " . g:screen_windowname . " -X stuff '" . substitute(a:text, "'", "'\\\\''", 'g') . "'")
endfunction

function Screen_Session_Names(A,L,P)
  return system("screen -ls | awk '/Attached/ {print $1}'")
endfunction

function Screen_Vars()
  if !exists("g:screen_sessionname") || !exists("g:screen_windowname")
    let g:screen_sessionname = ""
    let g:screen_windowname = "0"
  end

  let g:screen_sessionname = input("session name: ", "", "custom,Screen_Session_Names")
  let g:screen_windowname = input("window name: ", g:screen_windowname)
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if (! exists('no_plugin_maps') || ! no_plugin_maps)
    " Send selection
    vmap <Leader>r "cy:call Send_to_Screen(@c)<CR>

    " Send paragraph -- often misbehaves in python because interactive
    " python expects lots of whitespace after blocks
    nmap <Leader>r vip<Leader>r

    " Send entire file
    nmap <Leader>R 1GVG<Leader>r

    "nmap <C-c>v :call Screen_Vars()<CR>
endif
