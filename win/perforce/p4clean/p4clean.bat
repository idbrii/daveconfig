:: Deletes the file on disc and then reverts it. It works correctly on files
:: for edit and add. Import the xml files into P4V and copy this bat file to
:: C:\bin\p4clean.bat
::
del %1
p4 revert %1
