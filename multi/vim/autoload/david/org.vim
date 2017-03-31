" Take several estimates and find the sum.
"
" Assumes estimates are one per line, at the beginning of the line, and are in
" days.
function! david#org#sum_estimates() range
    let range = a:firstline .','. a:lastline
    " Clear lines without estimates
    '<,'>v/\dd/normal! 0C
    " Extract numbers
    '<,'>sm/\v^[^0-9-]+(.*\d)d.*/+\1
    " Use scriptease to add
    '<,'>normal gvg!
    " Re-add the d suffix
    normal! Ad
    nohl
endf
