" Use :make to check a layout
augroup Android
    au!
    " All android files are contained within my android workspace. Layout
    " files are in the layout folder.
    au BufRead,BufNewFile *.xml if match(expand('%:p'), '/android/', 0) >= 0 && match(expand('%:p'), '/res/layout/', 0) >= 0 | runtime ftplugin/android-layout.vim | endif
augroup END
