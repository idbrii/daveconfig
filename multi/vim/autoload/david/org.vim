" Take several estimates and find the sum.
"
" Assumes estimates are one per line, at the beginning of the line, and are in
" days.
function! david#org#sum_estimates() range
    '<,'>sm/d.*//
    '<,'>sm/^\s*/+/
    " Uses scriptease
    '<,'>normal gvg!
    nohl
endf
