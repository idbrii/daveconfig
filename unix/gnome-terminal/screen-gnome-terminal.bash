#! /bin/bash -i
# Source: http://agentzlerich.blogspot.com/2008/07/using-gnu-screen-with-gnome-terminals.html

# First, construct a new window identifier
WIN_ID=`date +%R:%S`

# Second, start a new window in the screen session using that identifier
screen -xRR -X screen -t "${WIN_ID}"

# Third, prevent existing terminals from switching to the new session 
# Thanks to nassrat for this tip 
screen -xRR -X other

# Now, use screen to connect to the new window within this process
exec screen -xRR -p "${WIN_ID}"
