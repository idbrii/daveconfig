" I already have a folding toggle.
silent! nunmap <buffer> <Tab>
" Use my unindent meaning for S-tab.
silent! nunmap <buffer> <S-Tab>
" Don't shadow gi. Also crw is more vim-like.
silent! nunmap <buffer> gil

" New bullets on CR and nothing on C-CR (like Slack).
imap <silent> <buffer> <CR> <Plug>OrgNewHeadingBelowInsert
inoremap <buffer> <C-CR> <CR>
