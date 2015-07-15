#! /bin/sh

serial=/dev/ttyS0
speed=38400
stty -F $serial $speed

# Log CLI readback
cat $serial > sw.txt &
readPid=$?

# Send commands
pause 0.5
printf "\n\n" > $serial
pause 0.5
printf "?\n" > $serial
pause 0.5

# Close file
kill $readPid
