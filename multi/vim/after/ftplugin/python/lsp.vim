
if lsp#get_server_status('pyls') == 'running'
    setlocal omnifunc=lsp#complete
endif

