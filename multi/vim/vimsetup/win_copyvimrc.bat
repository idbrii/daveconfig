@echo off

set destination=%USERPROFILE%
echo Copying vimrc and gvimrc to %destination%

copy .vimrc %destination%\_vimrc
copy .gvimrc %destination%\_gvimrc
