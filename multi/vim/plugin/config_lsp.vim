" I'm using ALE, so I don't want things to conflict
let g:lsp_diagnostics_enabled = 0

" To make lsp replace ALE:
"~ let g:lsp_diagnostics_enabled = 1
"~ let g:lsp_signs_enabled = 1         " enable signs
"~ let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
"~ let g:lsp_signs_error = {'text': '✗'}
"~ let g:lsp_signs_warning = {'text': '‼', 'icon': '/path/to/some/icon'} " icons require GUI
"~ let g:lsp_signs_hint = {'icon': '/path/to/some/other/icon'} " icons require GUI

augroup david_lsp
    au!

    " brew install luarocks
    "   or
    " scoop install luarocks # also requires visual studio for cl.exe
    " luarocks install luacheck
    " luarocks install --server=http://luarocks.org/dev lua-lsp
    if executable('lua-lsp')
        au User lsp_setup call lsp#register_server({
                    \ 'name': 'lua-lsp',
                    \ 'cmd': {server_info->['lua-lsp']},
                    \ 'whitelist': ['lua'],
                    \ })
    endif

    " pip install python-language-server
    if executable('pyls')
        au User lsp_setup call lsp#register_server({
                    \ 'name': 'pyls',
                    \ 'cmd': {server_info->['pyls']},
                    \ 'whitelist': ['python'],
                    \ })
    endif

augroup END
