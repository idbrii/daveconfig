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
    let is_linewise = mode() ==# 'V'
    let line_count = line(".") - line("v") + 1
    if is_linewise && line_count == 1
        return "\<Esc>\<Plug>Yssurround"
    else
        return "\<Plug>VSurround"
    endif
endf

function! david#editing#get_word_from_relative_line(offset)
    return matchstr(getline(line('.') + a:offset), '\v%'. virtcol('.') .'v%(\k+|.)')
endf


" gJ but always remove spaces when count is 1. Use 0gJ for default gJ
" behaviour.
function! david#editing#join_spaceless_single() abort
    normal! gJ

    " Remove whitespace.
    if v:count1 == 1 && matchstr(getline('.'), '\%' . col('.') . 'c.') =~ '\s'
        normal! "_dw
    endif
endf
function! david#editing#join_spaceless_multi() abort range
    let last = a:lastline
    if a:lastline == a:firstline
        let last += 1
    endif
    
    if v:count1 == 1
        let search_bak = @/
        exec printf('%i,%i sm/\v^\s+//e', a:firstline + 1, last)
        exec printf('%i,%i join!',       a:firstline,     last)
        let @/ = search_bak
    else
        normal! gJ
    endif
endf

