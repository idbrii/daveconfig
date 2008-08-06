" Insert Vim-version as X-Editor in mail headers
au FileType mail sil 1  | call search("^$")
             \ | sil put! ='X-Editor: Vim-' . Version()
