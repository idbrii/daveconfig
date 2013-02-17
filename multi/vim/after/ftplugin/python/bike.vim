" Bicycle Repair Man integration for Vim
"

if exists('loaded_python_bike') || &cp
    finish
endif

" Requires:
"   aptinstall bicyclerepair
let loaded_python_bike = david#load_system_vimscript('/usr/share/vim/addons/ftplugin/python_bike.vim')

