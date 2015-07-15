#! /bin/sh

switch_conf_file="./.conf_switch"
pause=0.2
serial_out="./sw_out.log"

# Load configuration
if [ ! -f "$switch_conf_file" ]; then
	echo "Error: Configuration file $switch_conf_file not found."
	exit 1
fi
echo "$switch_conf_file"
. "$switch_conf_file"

# Apply configuration
if [ -z "$switch_serial" ]; then
	echo "Error: Variable \$switch_serial not set"
	exit 1
fi
if [ -z "$switch_speed" ]; then
	echo "Error: Variable \$switch_speed not set"
	exit 1
fi
stty -F $switch_serial $switch_speed

# Log CLI readback
cat $switch_serial > $serial_out &
readPid=$?

# Send commands
sleep $pause
printf "\n" > $switch_serial
printf "exit\n" > $switch_serial
sleep $pause
printf "exit\n" > $switch_serial
sleep $pause
printf "exit\n" > $switch_serial
sleep $pause
printf "broadcast test\n" > $switch_serial
sleep $pause
sleep $pause
sleep $pause
printf "\n" > $switch_serial
sleep $pause


# Check if broadcast message was in console
$(grep --quiet "$switch_bcast_msg" "$serial_out")
loop_ok=$?
if [ $loop_ok -ne 0 ]; then
	echo "Error: Loop test failed"
	exit 1
fi
echo "Loop test succesful"

# Close file
kill $readPid
