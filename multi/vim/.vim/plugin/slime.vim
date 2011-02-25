" Author: Jonathan Palardy
" Send buffer contents to a screen session
" Source: http://technotales.wordpress.com/2008/10/17/screencast-like-slime-for-vim/
" Source: https://github.com/jpalardy/dotfiles/raw/master/vim/plugin/slime.vim
"
" Note: some maps clobber the c register
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function Slime_Send_to_Screen(text)
  if !exists("b:slime")
    call Slime_Screen_Vars()
  end

  let escaped_text = substitute(shellescape(a:text), "\\\\\n", "\n", "g")
  call system("screen -S " . b:slime["sessionname"] . " -p " . b:slime["windowname"] . " -X stuff " . escaped_text)
endfunction

function Slime_Get_Screen_Session_Names(A,L,P)
  return system("screen -ls | awk '/Attached/ {print $1}'")
endfunction

function Slime_Screen_Vars()
  if !exists("b:slime")
    let b:slime = {"sessionname": "", "windowname": "0"}
  end

  let b:slime["sessionname"] = input("session name: ", b:slime["sessionname"], "custom,Slime_Get_Screen_Session_Names")
  let b:slime["windowname"]  = input("window name: ", b:slime["windowname"])
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if (! exists('no_plugin_maps') || ! no_plugin_maps)
    " Make it easier to send a newline (useful in python to finish a block)
    nmap <Leader><Enter> :call Slime_Send_to_Screen("\n")<CR>

    " Send selection -- normal mappings call this one
    vmap <Leader>r "cy:call Slime_Send_to_Screen(@c)<CR>

    " Send paragraph -- often misbehaves in python because interactive
    " python expects lots of whitespace after blocks
    nmap <Leader>r m`vip<Leader>r``

    " Send entire file
    nmap <Leader>R 1GVG<Leader>r``

    "nmap <C-c>v :call Slime_Screen_Vars()<CR>
endif
