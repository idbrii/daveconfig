" Customize commands for submitting in vc.vim

" Load the default implementation.
runtime! bundle/vc/autoload/vc/commit.vim

"vc#commit.vim {{{1
fun! vc#commit#commitops(meta, cargs)  "{{{2
    let commitargs = {"meta": a:meta, "cargs":a:cargs}
    retu {
        \ "ZZ": {"fn": "vc#commit#commit", "args": commitargs,},
        \ "<c-q>": {"fn": "vc#commit#done", "args": []}, 
        \ }
endf

fun! vc#commit#commitopsdscr(meta) 
    retu [
        \ "ZZ: Commit Files",
        \ "Ctrl-q: Quit",
        \ ]
endf
"2}}}
