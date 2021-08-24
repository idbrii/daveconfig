
if executable('pandoc')
    function! david#markdown#Render(input_file, output_file) abort
        let in_file = a:input_file
        let out_file = a:output_file
        if empty(out_file)
            let out_file = tempname() ..'.html'
        endif
        let result = system(printf('pandoc -o %s %s', out_file, in_file))
        call OpenBrowser(out_file)
    endf
else
    function! david#markdown#Render(input_file, output_file) abort
        if executable('brew')
            let install = "Try: brew install pandoc"
        elseif executable('scoop')
            let install = "Try: scoop install pandoc"
        else
            let install = ""
        endif
        call david#warn("No pandoc found. " .. install)
    endf
endif

