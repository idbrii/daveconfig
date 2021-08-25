
function! david#git#peek_commit(sha) abort
    let text = systemlist("git -C ".. shellescape(FugitiveCommonDir()) .." log -n1 ".. a:sha)
    call setbufvar(winbufnr(popup_atcursor(text, { "padding": [1,1,1,1], "pos": "botleft", "wrap": 0 })), "&filetype", "git")
endf

function! david#git#peek_line() abort
    let tokens = getline('.')->split()
    if empty(tokens)
        return
    endif
    
    let sha = tokens[0]
    if str2nr(sha, 16) > 10000
        return david#git#peek_commit(sha)
    endif
endf
