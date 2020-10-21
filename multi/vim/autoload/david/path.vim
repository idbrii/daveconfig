if exists('&shellslash')
    function! david#path#to_unix(path)
        let shellslash_bak = &shellslash
        let &shellslash = 1
    
        let p = expand(a:path)
    
        let &shellslash = shellslash_bak
        return p
    endf

else
    function! david#path#to_unix(path)
        return expand(a:path)
    endf
endif
