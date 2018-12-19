:: Create a central server to edit in vim

:: Since we use remote-silent, we must send a file!
set placeholder_file=%1
if defined placeholder_file (
    set placeholder_file=
) else (
    set placeholder_file=hello-new-server
)

call gvim.bat --servername VIDE --remote-silent %placeholder_file% %*
