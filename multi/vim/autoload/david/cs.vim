if get(g:, 'OmniSharp_loaded', 0)
    function! david#cs#has_omnisharp_server()
        return OmniSharp#IsAnyServerRunning()
    endf
else
    function! david#cs#has_omnisharp_server()
        return 0
    endf
endif
