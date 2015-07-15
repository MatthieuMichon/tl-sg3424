# Serial Test

Tests basic connectivity betweent the host and the switch.

## Usage

`./serial_test.sh`

A configuration file called `.conf_switch` located in the same directory as the script file is required. This configuration file must contain the following variables:

* switch_serial: the serial port connected to the console port of the switch
* switch_speed: the speed in bauds of the serial connection
* switch_bcast_msg: The expected broadcast message announcement

```
switch_serial="/dev/ttyS0"
switch_speed=38400
switch_bcast_msg="Broadcast message from Console"
```

## Returns
```
Loop test succesful
Terminated
```

Output log file `sw_out.log `

```
TL-SG3424>exit


TL-SG3424>exit


TL-SG3424>exit


TL-SG3424>broadcast test
Broadcast message from Console
test


TL-SG3424>
```
