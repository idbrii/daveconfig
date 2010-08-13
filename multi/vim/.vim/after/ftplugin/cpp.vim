" Use :make to compile c, even without a makefile
" This is problematic with deep directories (and I don't understand glob)
"if glob('Makefile') == "" | let &mp="g++ -o %< %" | endif
setlocal cindent

if exists('loaded_cpp_extra') || &cp
    finish
endif
let loaded_cpp_extra = 1

runtime cscope_maps.vim

" macros
iabbrev _poff #pragma optimize("", off)
iabbrev _pon #pragma optimize("", on)
iabbrev #i #include
iabbrev #d #define
iabbrev D_P DBG_PRINT
iabbrev _guard_ #ifndef zzz<CR>#define zzz<CR><CR>#endif<ESC>kO

" Fast switch between header and implementation (instead of lookup file)
"
" Source: http://vim.wikia.com/wiki/Easily_switch_between_source_and_header_file#By_modifying_ftplugins
function SwitchSourceHeader()
    if (expand ("%:t") == expand ("%:t:r") . ".cpp")
        find %:t:r.h
    else
        find %:t:r.cpp
    endif
endfunction

nnoremap <A-o> :call SwitchSourceHeader()<CR>
