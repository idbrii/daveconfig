if get(g:, 'OmniSharp_loaded', 0)
    function! david#cs#has_omnisharp_server()
        " This is only updated when editing C# files.
        return len(get(g:, 'OmniSharp_server_ports', [])) > 0
    endf
else
    function! david#cs#has_omnisharp_server()
        return 0
    endf
endif
