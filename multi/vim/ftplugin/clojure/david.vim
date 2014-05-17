" syntax doesn't work -- why?
" g:clj_want_folding is useless?
setlocal foldmethod=indent
" There's probably something in vimclojure to do this, but how does it work?
nmap <buffer> -- ggVGy<C-w><C-w>Gpi<CR><CR><C-w><C-w>``
vmap <buffer> -- y<C-w><C-w>Gpi<CR><CR><C-w><C-w>``

" Show documentation in repl (assumes repl is top window)
nmap <buffer> K :let clj_doc = expand("<cword>")<CR>:wincmd k<CR>Go(doc <C-r>=expand(clj_doc)<CR>)<CR>
vmap <buffer> K y:wincmd k<CR>Go(doc <Esc>pA)<CR>

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
        call ClojureReplServerStart()
    endif
endfunction

" Use bar instead of putting it into a function because that doesn't work
command ClojureReplStart call <SID>ClojureReplStart() | call vimclojure#Repl.New()
