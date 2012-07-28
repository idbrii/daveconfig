
" For some reason, VimOrganizer doesn't come with this.
au BufRead,BufNewFile *.org            call org#SetOrgFileType()
