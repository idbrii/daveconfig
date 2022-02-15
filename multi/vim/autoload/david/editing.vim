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


function! david#editing#ScripteasePreFilter_StripSuffix(expr)
  " Strip out f float suffixes.
  return substitute(a:expr, '\v\C(\d)f>', '\1', 'g')
endf
function! david#editing#ScripteasePostFilter_StripSuffix(expr, filter_modified, original)
  if a:filter_modified
    " We had f suffixes, so restore them.
    return substitute(a:expr, '\v\C([0-9.]+)>', '\1f', 'g')
  endif
  return a:expr
endf

" TODO: try stripping out junk and then send it to g= instead of my own eval.
" (Would that be any better?)
" I think this is supposed to find numbers inside text to help with summing
" estimates.
function! david#editing#FilterNumbersFromWords(count) abort
    let c_bak = @c
    try
        let cnt = 1 " max([1, a:count])
        exec 'norm! "cd'.. cnt ..'_'
        let code = @c

        let comment = david#get_single_line_comment_leader()
        let segments = matchlist(code, '\v\C'..'^(\s*%('..comment..')?\s*%(\k+\s*\=\s*))(.*)(;\s*%('..comment..')?\n)')
        if len(segments) < 4
            let g:DAVID_test = @c
            norm! "cP
            echoerr "Failed to find numbers:"
            echom 'norm! "cd'.. cnt ..'_'
            echom code
            echom "Found:"
            echom segments
            return
        endif

        let code = segments[2]

         "  51.5 + 12.3
         "  51.5f + 12.3;

        " absolute_y = 51.5f + 12.3;
        " absolute_y = 51.5f + 12.3;
        " absolute_y = 51.5f + 12.3;
        " absolute_y = 51.5f + 12.3;

        " f suffix for floats
        let no_f = substitute(code, '\v\C'..'(\d)f>', '\1', 'g')
        let add_f = no_f != code
        let code = no_f

        try
            let code = string(eval(code))
        catch
            norm! "cP
            echoerr "Failed eval("..code..")"
            throw v:exception
        endtry

        if add_f
            let code = substitute(code, '\v\C([0-9.]+)', '\1f', '')
        endif

        let @c = segments[1] .. code .. segments[3]
        norm! "cP

    finally
        let @c = c_bak
    endtry
endf
