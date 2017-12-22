" Code used in vimrc and other sourced-on-startup
" (No lazy loading here!)

function! david#init#find_ft_match(ft_list)
    return match(a:ft_list, printf("\\v<%s>", &ft))
endf
