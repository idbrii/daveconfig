" Sum up estimates and display them next to headings

let s:textprop_next_id = 0
let s:popup_ids = []
let s:textprop_type = 'estimate-marker'

function! david#org#sum_estimates() abort range
    call david#org#clear_popups()

    if empty(prop_type_get(s:textprop_type))
        try
            call prop_type_add(s:textprop_type, { 'bufnr': bufnr() })
        catch /^Vim\%((\a\+)\)\=:E969/	" Property type estimate-marker already defined
            " Don't care
        endtry
    endif

    let bounds = [a:firstline, a:lastline]
    for summary in david#org#compute_sums(a:firstline, a:lastline)
        call david#org#create_estimate_summary_popup(summary, bounds)
    endfor
    command! -buffer SumEstimatesClear call david#org#clear_popups()
endf


function! david#org#clear_popups()
    for winid in s:popup_ids
        call popup_close(winid)
    endfor
    let s:popup_ids = []
    call prop_remove({ 'type' : s:textprop_type }, 1, line('$'))
endf

function! david#org#compute_sums(firstlnum, lastlnum) abort
    let range = getline(a:firstlnum, a:lastlnum)
    let unit_to_hours = {
                \ 'h' : 1,
                \ 'd' : 8,
                \ }
    let headers = []
    let sum_per_header = {}
    let lnum = a:firstline - 1
    let last_header = 'untitled'
    let sum_per_header[last_header] = 0
    for line in range
        let lnum += 1
        let h = matchstr(line, '\v^#\s?\zs.*')
        if !empty(h) && h !~# '# vim:'
            call add(headers, [lnum, h])
            let sum_per_header[h] = 0
            let last_header = h
            continue
        endif
        let content = matchlist(line, '\v^[^0-9-]+(\d+)([hd])')
        if !empty(content)
            let unit = content[2]
            let hours = str2float(content[1]) * unit_to_hours[unit]
            let sum_per_header[last_header] += hours
        endif
    endfor

    let sums = []
    for lnum_and_header in headers
        let r = {}
        let r.lnum = lnum_and_header[0]
        let r.header = lnum_and_header[1]
        let hours = sum_per_header[r.header]
        if hours <= 0
            continue
        endif
        let days = hours * 0.125
        let r.hours = hours
        let r.text = printf("%.1fd or %.0fh", days, hours)
        if &verbose > 0
            " Print header for verification
            let r.text = r.header .' '. r.text
        endif
        call add(sums, r)
    endfor
    return sums
endf

function! david#org#create_estimate_summary_popup(summary, bounds)
	let lnum = a:summary.lnum
	let col = 1
	let len = 2 + len(a:summary.header)
	let prop_id = s:textprop_next_id
	call prop_add(lnum, col, #{
		\ length: len,
		\ type: s:textprop_type,
		\ id: prop_id,
		\ })

	let winid = popup_create(a:summary.text, #{
		\ pos: 'topleft',
		\ textprop: s:textprop_type,
		\ textpropid: prop_id,
		\ col: 5,
		\ line: -1,
		\ border: [0,0,0,0],
		\ padding: [0,1,0,1],
		\ close: 'click',
		\ })
		"~ \ moved: a:bounds,
    let s:textprop_next_id += 1
    call add(s:popup_ids, winid)
endf
