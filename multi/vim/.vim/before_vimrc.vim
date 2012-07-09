" Before Vimrc
"
" This file is sourced at the beginning of the vimrc. Put anything here that
" many other things depend on and must be done first.


" Pathogen
" Load immediately -- it loads other plugins, so do it first.
call pathogen#runtime_append_all_bundles()


" Yankstack
" Load immediately -- is clobbers some base commands, so if those are
" remapped, it will clobber your remapping. Also disable maps since those are
" applied when yankstack is autoloaded.
let g:yankstack_map_keys = 0
call yankstack#setup()
