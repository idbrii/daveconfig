:: Open an rxvt terminal                                       
:: Fanciness required because rxvt fails to read my bashrc     
start %cyg_bin%\rxvt.exe -bg black -sl 8192 -fg white -sr -g 100x40 -fn "Fixedsys" -e /usr/bin/bash --login -i -c "exec bash -i"
