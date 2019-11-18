" Add incrementing numbers to beginning of lines in range.
" Argument is number for first line.
command! -nargs=* -range IncrementorInsert call david#incrementor#insert_leading_numbers(<line1>,<line2>,<f-args> + 0)
" Create :sub command to insert incrementing numbers to search in range.
" Argument is number for first line.
command! -nargs=* -range IncrementorBuildRegex call david#incrementor#prep_regex(<line1>,<line2>,<f-args> + 0)
