" Add menu items

" Note: This only works if eclim is running _before_ vim is launched.
" Actually, the eclimd_running variable doesn't seem to work at all.

if exists("g:eclimd_running") && g:eclimd_running

    " I added my package prefix to Eclipse's Organize Imports setting and now
    " eclim and eclipse appear to be consistent in how they sort.
    let g:EclimJavaImportPackageSeparationLevel = 1
    function! JavaCleanupFile()
        JavaImportMissing
        JavaImportClean
        JavaImportSort
        %JavaFormat
        Validate
    endfunction

    " imports whatever is needed
    menu E&clim.ImportMissing :JavaImportMissing<CR>
    menu E&clim.ImportPrettify :JavaImportClean<CR>:JavaImportSort<CR>

    menu E&clim.Prettify :call JavaCleanupFile()<CR>

    " opens javadoc for statement in browser
    menu E&clim.JavaDocSearch  :JavaDocSearch -x declarations<CR>

    " searches context for statement
    menu E&clim.JavaSearchContext :JavaSearchContext<cr>

    " validates current java file
    menu E&clim.Validate :Validate<CR>

    " shows corrections for the current line of java
    menu E&clim.JavaCorrect :JavaCorrect<CR>

    " 'open' on OSX will open the url in the default browser without issue
    "let g:EclimBrowser='open'
endif
