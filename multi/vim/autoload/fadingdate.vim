function! s:ColorizeDates(year_start, year_end)
    let min_color = [0x00, 0x45, 0x00]
    let max_color = [0x10, 0xff, 0xff]
    let increment = 0x10
    let color = min_color[:] " copy
    for year in range(a:year_start, a:year_end)
        for month in range(1, 12)
            let date_id = printf('Date-%04d%02d', year, month)
            let cmd = printf('syntax match %s "^%04d-%02d-\d\d"', date_id, year, month)
            call execute(cmd)

            let fg = ''
            if s:Sum(color) > 0xdd
                " Too bright for white.
                let fg = 'guifg=black'
            else
                let fg = 'guifg=white'
            endif
            
            let cmd = printf('highlight %s guibg=#%02x%02x%02x %s', date_id, color[0], color[1], color[2], fg)
            call execute(cmd)

            let found_new_color = 0
            for i in range(0, len(color)-1)
                let color[i] += increment
                if color[i] < max_color[i]
                    let found_new_color = 1
                    break
                endif
                let color[i] -= increment
            endfor

            if !found_new_color
                "~ echoerr "Ran out of colours."
                "~ return
            endif
        endfor
    endfor
endf

function! s:Sum(numbers)
    let sum = 0
    for v in a:numbers
        let sum += v
    endfor
    return sum
endf

function! s:FindDateRangeInBuffer()
    let dates = {}
    let lines = getline(1, "$")
    for line in lines
        let d = line[0:3]
        "~ if d =~# '^\v\d{4}-\d{2}$'
        if d =~# '^\v\d{4}$'
            let dates[d] = 1
        endif
    endfor
    let dates = sort(keys(dates))
    if len(dates) > 0
        return map([dates[0], dates[-1]], 'str2nr(v:val)')
    endif
    return 
endf


function! fadingdate#ColorizeDatesInBuffer()
    let s:dates = s:FindDateRangeInBuffer()
    call s:ColorizeDates(s:dates[0], s:dates[1])
endf

" Add this to buffers where dates would be in this format.
"~ command! -buffer -bar 		FadeDateColors call fadingdate#ColorizeDatesInBuffer() 

" Testing:
" nnoremap <buffer> \\ :<C-u>update<Bar>wincmd p<Bar>source ~/.vim/waitingroom/fadingdate.vim<Bar>ColorizeDates<Bar>wincmd w<CR>
