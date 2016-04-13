" SaveCurrentFont
"   Adds the current font settings to your gvimrc
" Author: David Briscoe
"
" It's a pain to remember the names of fonts when adding them to your config,
" so this function automates that process by using the current font settings.
"
" Just call SaveCurrentFont() to save the current font.
function! s:SaveCurrentFont()
    " Copy the current font setting into our a register
    " and modify it to be a :set line
    let @a=&gfn
    let @a=substitute(@a, " ", "\\\\ ", "g")
    let @a=substitute(@a, "^", "set guifont=", "")

    edit $MYGVIMRC

    " Go to the end of the gvimrc file
    normal G
    " Paste the font setting
    silent put a

    " We don't save the file because we want to make sure the user knows
    " what's changed (using stuff like DiffOrig).
endfunction

command! ConfigAddCurrentFont call s:SaveCurrentFont()
