function! <SID>ClearRegisters(registers)
    for i in range(strlen(a:registers))
        " assign each register the value of the black hole
        exec "let @" . a:registers[i] . " = @_"
    endfor
endfunction

call <SID>ClearRegisters("qwertyuiopasdfghjklzxcvbnm")
call <SID>ClearRegisters("1234567890")
echo 'Restart vim to see cleared registers in :registers'
