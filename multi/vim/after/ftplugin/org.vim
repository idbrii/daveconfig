" I already have a folding toggle.
silent! nunmap <buffer> <Tab>
" Use my unindent meaning for S-tab.
silent! nunmap <buffer> <S-Tab>
" Don't shadow gi. Also crw is more vim-like.
silent! nunmap <buffer> gil

" New bullets on CR and nothing on C-CR (like Slack).
function! s:NewHeadingAtEndOfLine()
    let is_at_end_of_line = col(".") >= col("$")-1
    " Only do new headings when at the end of a line since that's more
    " expected (better than Slack).
    if is_at_end_of_line
        return "\<Plug>OrgNewHeadingBelowInsert"
    else
        return "\<CR>"
    endif
endfunction
imap <silent> <buffer> <expr> <CR> <SID>NewHeadingAtEndOfLine()
inoremap <buffer> <C-CR> <CR>
