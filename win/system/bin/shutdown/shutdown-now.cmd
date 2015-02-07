shutdown /s /t 5 /c "Shutting down"

::    /s         Shutdown the computer.
::    /t xxx     Set the time-out period before shutdown to xxx seconds.
::               The valid range is 0-315360000 (10 years), with a default of 30.
::               If the timeout period is greater than 0, the /f parameter is
::               implied.
::    /c "comment" Comment on the reason for the restart or shutdown.
::               Maximum of 512 characters allowed.
