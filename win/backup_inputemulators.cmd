:: Copy input emulator config files to daveconfig
::
:: Don't need to copy freepie because it's loaded directly out of daveconfig.
setlocal
pushd c:\

set destination=c:\david\settings\daveconfig\win\DS4Windows

xcopy /I /Y c:\david\game\DS4Windows\Profiles\* %destination%\Profiles\
xcopy /I /Y c:\david\game\DS4Windows\*.xml %destination%\


set destination=c:\david\settings\daveconfig\win\JoyToKey

xcopy /I /Y /EXCLUDE:%~dp0\exclude_bin c:\david\game\JoyToKey %destination%\




popd
