
" Can't do this until after the omnisharp variable is defined. Can't set that
" variable myself or it won't allow installs.
" TODO: This doesn't work. The server doesn't finish initializing and we don't
" correctly detect our root (where the .sln is located). vim-omnisharp starts
" the server with a port and the location of the sln.
"~ let g:lsp_settings['omnisharp-lsp'].cmd = [g:OmniSharp_server_install . '/OmniSharp.exe', '-lsp']
"~ let g:lsp_settings['omnisharp-lsp'].root_uri_patterns = ['*.sln'] + g:lsp_settings_root_markers
