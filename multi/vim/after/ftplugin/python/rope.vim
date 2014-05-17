" Rope refactoring integration for Vim
"

if exists('loaded_python_rope') || &cp
    finish
endif

" Requires:
"   pip install ropemode
"   pip install ropevim
let loaded_python_rope = david#load_system_vimscript('/usr/local/ropevim.vim')

