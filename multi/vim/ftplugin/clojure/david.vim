" Some shortcuts for server functionality
if exists("g:loaded_clojure_david")
	finish
endif
let g:loaded_clojure_david = 1

let s:NailgunClient = "$HOME/.clojure-vim/ng"
let vimclojure#NailgunClient = s:NailgunClient
let s:clojure_david_server_active = 0

function ClojureReplServerStart()
    ! sh ~/.vim/scripts/ng-server &
    let s:clojure_david_server_active = 1
endfunction
"command ClojureReplServerStart call <SID>ClojureReplServerStart()

function ClojureReplServerEnd()
    exec '! ' . s:NailgunClient . ' ng-stop'
    let s:clojure_david_server_active = 0
endfunction
"command ClojureReplServerEnd call <SID>ClojureReplServerEnd()

function <SID>ClojureReplStart()
    if s:clojure_david_server_active == 0
        echo 'hello'
        call ClojureReplServerStart()
    endif
endfunction

" Use bar instead of putting it into a function because that doesn't work
command ClojureReplStart call <SID>ClojureReplStart() | call vimclojure#Repl.New()
