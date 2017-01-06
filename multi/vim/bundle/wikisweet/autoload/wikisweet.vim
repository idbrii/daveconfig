" Build the name of the function for formatting links for this filetype.
function! s:filetype_to_format_function(filetype)
	return 'wikisweet#'. a:filetype .'#FormatLinkForFiletype'
endfunction

" Convert a url to the input filetype. 
function! wikisweet#UrlToWikiLink(desired_filetype)
    let c_backup = @c

    normal! "cyiW
    let url = @c
    let name = wikisweet#UrlToName(url)
    let format_function = s:filetype_to_format_function(a:desired_filetype)
    if !exists('*'. format_function)
		let format_function = s:filetype_to_format_function('markdown')
    endif
	exec 'let @c = '. format_function .'(name, url)'
    normal! viW"cp

    let @c = c_backup
endf

" Convert a url to a human-readable name.
"
" Essentially truncates to the page name and converts some characters to
" spaces.
function! wikisweet#UrlToName(url)
    let c_backup = @c
    let lazy_backup = &lazyredraw

    Scratch
    0put =a:url
    ConvertFromUrlEncoding
    normal! "cdiW
    bdelete
	let name = @c
	let name = substitute(name, '^.*/', '', '')
	let name = substitute(name, '+', ' ', 'g')
	let name = substitute(name, '-', ' ', 'g')

    let &lazyredraw = lazy_backup
    let @c = c_backup
    return name
endf
