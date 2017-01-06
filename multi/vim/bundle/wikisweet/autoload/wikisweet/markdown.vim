function! wikisweet#markdown#FormatLinkForFiletype(name, url)
	return '['. a:name .']('. a:url .')'
endfunction
