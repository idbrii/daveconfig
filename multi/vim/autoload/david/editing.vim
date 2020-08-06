" Text editing

" Source: https://vim.fandom.com/wiki/Switching_case_of_characters#Twiddle_case
function! david#editing#ToTitleCase(str)
    let result = tolower(a:str)
    let result = substitute(result,'\v(<\w\w+>)', '\u\1', 'g')
    return result
endfunction

function! david#editing#ToSnakeCase(str)
    let result = tolower(a:str)
    let result = substitute(a:str,'\v +', '_', 'g')
    return result
endfunction

" For xmap s: Behave like yss if single line is selected.
" Allows me to use s for no newlines and S for add newlines.
function! david#editing#xsurround() abort range
    let is_linewise = visualmode() ==# 'V'
    let cmd = nr2char(getchar())
    let line_count = a:lastline - a:firstline + 1
    if is_linewise && line_count == 1
        exec "normal \<Plug>Yssurround" .. cmd
    else
        exec "normal gv\<Plug>VSurround" .. cmd
    endif
endf

function! david#editing#get_word_from_relative_line(offset)
    return matchstr(getline(line('.') + a:offset), '\v%'. virtcol('.') .'v%(\k+|.)')
endf
