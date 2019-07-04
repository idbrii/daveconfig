" Text editing

" Source: https://vim.fandom.com/wiki/Switching_case_of_characters#Twiddle_case
function! david#editing#ToTitleCase(str)
    let result = tolower(a:str)
    let result = substitute(result,'\v(<\w\w+>)', '\u\1', 'g')
    return result
endfunction

function! david#editing#ToSnakeCase(str)
    let result = tolower(a:str)
    let result = substitute(a:str,'\v +', '_', 'g')
    return result
endfunction
