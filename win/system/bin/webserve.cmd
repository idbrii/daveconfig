start http://localhost:8000

@echo off

python3 -m http.server 8000 --bind 127.0.0.1
if %ERRORCODE% (
    echo "Failed to find python3. Falling back to python 2.7."
    python -m SimpleHTTPServer
)
