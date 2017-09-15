function! david#incrementor#reset_incrementing_number(...)
    " First arg is the initial value.
    if a:0 > 0
        let s:incrementor_value = a:1
    else
        let s:incrementor_value = 0
    endif

    " Second arg is amount to increment by.
    if a:0 > 1
        let s:incrementor_increment = a:2
    else
        let s:incrementor_increment = 1
    endif

    " We increment before use, so decrement up front.
    let s:incrementor_value -= s:incrementor_increment

    echo 'Use a command like %sm//\=david#incrementor#get_incrementing_number() + submatch(0)'
endf
function! david#incrementor#get_incrementing_number()
    let s:incrementor_value += s:incrementor_increment
    return s:incrementor_value
endf
