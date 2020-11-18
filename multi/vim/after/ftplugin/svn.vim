
" In svn commit buffers, wrap automatically at 78 chars.
" If I ever use svn again, I may want to replace this with a better plugin. (I
" pulled this out of my vimrc.)
setlocal tw=78 fo+=t

" verbose commit messages are full of diffs which have nonsense indentation.
" Stick with defaults and don't detect.
let b:detectindent_has_tried_to_detect = 1
