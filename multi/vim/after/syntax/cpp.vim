" These are the parts of vim-cpp-modern that aren't STL and aren't covered by
" the built-in syntax.

if get(g:, 'cpp_attributes_highlight', 0)
    syntax region cppAttribute matchgroup=cppAttributeBrackets start='\[\[' end=']]' contains=cString
    hi def link cppAttribute         Macro
    hi def link cppAttributeBrackets Identifier
endif

if !exists('cpp_no_cpp11')
    syntax keyword cppType char16_t char32_t
end

hi def link cppStatement       Statement
hi def link cppType         Type
