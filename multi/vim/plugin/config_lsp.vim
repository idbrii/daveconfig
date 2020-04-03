" I'm using ALE, so I don't want things to conflict
let g:lsp_diagnostics_enabled = 0

" To make lsp replace ALE:
"~ let g:lsp_diagnostics_enabled = 1
"~ let g:lsp_signs_enabled = 1         " enable signs
"~ let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
"~ let g:lsp_signs_error = {'text': '✗'}
"~ let g:lsp_signs_warning = {'text': '‼', 'icon': '/path/to/some/icon'} " icons require GUI
"~ let g:lsp_signs_hint = {'icon': '/path/to/some/other/icon'} " icons require GUI

" Default omnifunc to lsp.
set omnifunc=lsp#complete

" vim-lsp doesn't do anything smart to find what to hover, so make our own.
command! HoverUnderCursor LspHover expand('<cword>')

augroup david_lsp
    au!

    " # lua-lsp
    " brew install luarocks
    "   or
    " scoop install luarocks # also requires visual studio for cl.exe
    " luarocks install luacheck
    " luarocks install --server=http://luarocks.org/dev lua-lsp
    "
    " # emmylua-ls
    " install openjdk
    " LspInstallServer
    if executable('lua-lsp') || executable(lsp_settings#servers_dir() .'/emmylua-ls/emmylua-ls')
        let g:lua_define_omnifunc = 0
        let g:lua_define_completion_mappings = 0
        if executable('lua-lsp')
            au User lsp_setup call lsp#register_server({
                        \ 'name': 'lua-lsp',
                        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'lua-lsp']},
                        \ 'whitelist': ['lua'],
                        \ })
        endif
        " vim-lsp-settings handles setup for emmylua
    endif

    " pip install python-language-server

augroup END
