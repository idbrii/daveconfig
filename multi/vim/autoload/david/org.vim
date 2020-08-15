" Take several estimates and find the sum.
"
" Assumes estimates are the first number in a line and are in days or hours.
function! david#org#sum_estimates() range
    let range = a:firstline .','. a:lastline
    " Clear lines without estimates
    '<,'>v/\d[hd]/normal! 0D
    " Extract numbers
    '<,'>sm/\v^[^0-9-]+(.*\d)d.*/+\1*8h/e
    '<,'>sm/\v^[^0-9-]+(.*\d)h.*/+\1/e
    " Use scriptease to add
    '<,'>normal gvg!
    '<,'>sm/\v(\d+)/\=printf("%.1fd", submatch(1) * 0.125) ..' or '.. submatch(1) ..'h'/
    nohl
endf
