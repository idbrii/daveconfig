function! wikisweet#html#FormatLinkForFiletype(name, url)
	return printf('<a href="%s">%s</a>', a:url, a:name)
endfunction
