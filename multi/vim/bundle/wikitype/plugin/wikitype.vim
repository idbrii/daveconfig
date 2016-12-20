if exists('loaded_wikitype') || &cp || version < 700
	finish
endif
let loaded_wikitype = 1

nnoremap crw :<C-u>call wikitype#UrlToWikiLink(&filetype)<CR>
