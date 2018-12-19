" Source: https://vi.stackexchange.com/questions/8718/vim-switch-statement-cindent-options/8722#8722

function! david#indent#SetupCindentWithNiceSwitchIndents()
    " TODO: Don't see why comment would be necessary for indent? Because
    " comment check only looks for /*?
    "~ setlocal comments=s1:/*,mb:*,ex:*/

    setlocal cindent
    " I don't think I like (0
    setlocal cinoptions=Ls,t0,(0

    setlocal indentexpr=david#indent#GetCaseBlockCorrectedIndent()
    setlocal indentkeys=!^F,0{,0},0),0#,o,O,e,:
endf

function! s:PrevNonBlankOrComment(startlnum)
    let lnum = a:startlnum
    while lnum > 0
        let lnum = prevnonblank(lnum)
        if (getline(lnum) =~ '\v^\s*(/|\*)')
            let lnum -= 1
        else
            break
        endif
    endwhile
    return lnum
endfunction

function! david#indent#GetCaseBlockCorrectedIndent()
    let lnum = v:lnum
    let prevlnum = s:PrevNonBlankOrComment(lnum - 1)
    let idnt = cindent(v:lnum)
    let adj = 0
    if getline(prevlnum) =~ '^\s*case\>' && getline(lnum) =~ '^\s*{'
       let adj = -&shiftwidth
    endif
    return idnt + adj
endfunction
