" Expose bufkill interface for bbye.
"
" I migrated from bufkill to bbye since I think it will elimiate the
" occasional errors I get. bbye doesn't use autocmds.
" This is mostly to keep my scripts working.

command! -bang BD :Bdelete<bang>
command! -bang BW :Bwipeout<bang>
