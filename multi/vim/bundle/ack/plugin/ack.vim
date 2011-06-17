" NOTE: You must, of course, install the ack script
"       in your path.
" On Ubuntu:
"   sudo apt-get install ack-grep
"   ln -s /usr/bin/ack-grep /usr/bin/ack
" With MacPorts:
"   sudo port install p5-app-ack

if exists('g:loaded_ack')
    finish
endif
let g:loaded_ack = 1

let s:save_cpo = &cpo
set cpo&vim

if exists('g:ack_prg')
  let s:prg = g:ack_prg
elseif executable('ack-grep')
  " Ack-grep is used for Debian/Ubuntu
  let s:prg = "ack-grep"
else
  let s:prg = "ack"
endif

function! Ack(command, args)
  let cmd = s:prg . " -H --nocolor --nogroup --column " . a:args
  if a:args =~ '\m\C\<-[gf]\>'
    let format = "%f"
  else
    let format = "%f:%l:%c:%m"
  endif
  let title = '[Found: %s] Ack ' . substitute(a:args, '%', '%%', 'g')
  let env = call(a:command, [format, title])
  call asynccommand#run(cmd, env)
endfunction

command! -nargs=+ -complete=file Ack     call Ack("asynccommand#quickfix",     <q-args>)
command! -nargs=+ -complete=file AckAdd  call Ack("asynccommand#quickfix_add", <q-args>)
command! -nargs=+ -complete=file LAck    call Ack("asynccommand#loclist",      <q-args>)
command! -nargs=+ -complete=file LAckAdd call Ack("asynccommand#loclist_add",  <q-args>)
command! -nargs=+ -complete=file AckG    call Ack("asynccommand#quickfix",     <q-args>)

let &cpo = s:save_cpo
