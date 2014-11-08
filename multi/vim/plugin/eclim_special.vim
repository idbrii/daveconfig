" Add menu items

" Note: This only works if eclim is running _before_ vim is launched.

if exists("g:eclimd_running") && g:eclimd_running
    " Add an alternate to lookupfile to use Eclim's project searching -- great
    " for libraries (which are in a different project root).
    " Note: don't have a good alternate right now.
    "nnoremap <A-S-o> :LocateFile<CR>

    " Use Eclim's user-defined completion instead of omnicompletion
    inoremap <C-Space> <C-x><C-u>
endif
