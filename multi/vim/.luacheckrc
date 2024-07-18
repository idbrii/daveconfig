
ignore = {
    '121', -- Setting read-only global variable.
    '122', -- Setting a read-only field of a global variable.
    '211/test_.*', -- unused function for testy tests.
    '212', -- Unused argument.
    '311', -- Value assigned to a local variable is unused.
    '631', -- max_line_length.
}

-- nvim api
read_globals = {
    "vim",
}

-- vim: ft=lua
