" Font exploration.

" I grabbed a bunch of fonts:
" * http://www.proggyfonts.net/download/
" * https://github.com/mozilla/Fira/releases/tag/4.202
" I mostly grabbed what looked appealing or I'd seen recommended.
" After all of that, I found http://app.programmingfonts.org which semes like
" a better way to explore.
"
" Below I wrote my evaluation of each.

let s:font_idx = 0
let s:font_list = []

" Small font (fixed size. blurry when scaled.)
" Astoundingly small.
call insert(s:font_list, "ProggySmallTT:h12:cANSI:qDRAFT")
" Very small
call insert(s:font_list, "ProggySquareTT:h12:cANSI:qDRAFT")
" >> Love it
call insert(s:font_list, "ProggyCleanTT:h12:cANSI")
" Weirdly low x height
call insert(s:font_list, "Crisp:h12:cANSI:qDRAFT")
" Too many small details at small size (s and a have tiny gaps).
call insert(s:font_list, "PixelCarnageMonoTT:h12:cANSI:qDRAFT")

" Bigger font (scalable)
" Weirdly low x height at small sizes.
call insert(s:font_list, "Consolas:h11:cANSI:qDRAFT")
" >> Looks pretty good.
call insert(s:font_list, "Fira_Mono:h11:cANSI:qDRAFT")
" Simplified descenders (g) and other shapes, but small gaps in small
" letters like e looks blurry.
call insert(s:font_list, "DejaVu_Sans_Mono:h11:cANSI:qDRAFT")


function! s:wrapped_increment(current, bound)
    let val = a:current + 1
    let val = val % a:bound
    return val
endf

function! s:next_font()
    let s:font_idx = s:wrapped_increment(s:font_idx, len(s:font_list))
    let next_font = s:font_list[s:font_idx]
    exec 'set guifont='. next_font
    " Force redraw to ensure echo is displayed.
    redraw!
    echo next_font
endf

command! SwitchFont call s:next_font()
