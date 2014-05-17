" Override settings from vim-sensible.

set scrolloff=3				" Keep 3 lines below and above cursor
set noautowrite

" Make Y work with yankstack (needs nmap).
" TODO: should map directly to yankstack?
nmap Y y$
