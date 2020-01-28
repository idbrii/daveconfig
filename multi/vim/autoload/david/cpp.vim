
" Fast switch between header and implementation (instead of lookup file)
"
" Source: http://vim.wikia.com/wiki/Easily_switch_between_source_and_header_file#By_modifying_ftplugins
function! david#cpp#SwitchSourceHeader()
    " Ensure we're in the directory of the current file so `find` is looking
    " in the right tree.
    silent! cd %:p:h

    try
        if (expand("%:t") == expand("%:t:r") . ".h")
            try
                find %:t:r.cpp
            catch /^Vim\%((\a\+)\)\=:E345/
                " Error: Can't find file. Try inline instead.
                find %:t:r.inl
            endtry
        else
            find %:t:r.h
        endif
    catch /^Vim\%((\a\+)\)\=:E345/
        " If we can't find it in the path, see if it's in unite.
        if exists(":UniteSameName")
            UniteSameName
        endif
    endtry
endfunction

