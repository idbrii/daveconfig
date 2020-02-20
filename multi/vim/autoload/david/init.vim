" Code used in vimrc and other sourced-on-startup
" (No lazy loading here!)

function! david#init#find_ft_match(ft_list)
    return index(a:ft_list, &ft)
endf
