function! david#folding#diff#Fold_CmdsAndHunks(lnum)
    " Fold a diff output as title and hunks underneath it. A big patch should
    " collapse to a bunch of diff commands with only 
    let line = getline(a:lnum)
    if line =~ '^diff '
        " Command as title
        return '>1'
    elseif line =~ '^\(---\|+++\|@@\) '
        " Diff blocks/hunks as subtitle
        return '>2'
    elseif line[0] =~ '[-+ ]'
        " Diff line is fold content
        return 2
    else
        " Add/delete files, index, etc are expanded with diff
        return -1
    endif
endfunction
