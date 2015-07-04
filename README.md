# TP-Link TL-SG3424 Series Ethernet Switch

This repo contains stuff related to this network switch.

# Setup

The setup can be performed using three different solutions:

* Web GUI
* SSH CLI
* Serial CLI

The web GUI is not that awful  (i.e. nothing like the H3C / HP A5120 EI series) but could be more snappier especially when using SSL which is what everybody should do (right ?). Still using HTTPS is not nerdy enough so the next best thing would be SSH.

Connecting trough SSH is straitghtforward:

```bash
$ ssh <switch mgt IP>
[...]
Authenticated with partial success.
admin@<switch mgt IP>'s password: 

TL-SG3424>
```

The switch configuration commands require *privileged EXEC mode*. However this mode cannot be entered through SSH without having configured a password:

```
TL-SG3424>enable
No password set
```

After messing around with the web GUI, SSH access is still a no-avail.

Reading the CLI document explains that telnet (yeah!) requires some initial setup using the serial console. I guess that SSH would be the same as this would explain our problem. So now is time go full analog and use the provided RJ45 / D-Sub cable (thanks TP-Link, although in this age a RJ45/USB serial cable would be more convienient).


## Serial Console

### Connection

Install `screen` and connect through the serial port:

```bash
$ sudo apt-get install screen
$ sudo screen /dev/ttyS0 38400
[press enter]
TL-SG3424>
```
Note: This switch uses a rather odd **38400** baud/s rate, instead of your usual 9600 or 115200.

### Configuration

| Command | CLI Help Description | Remarks |
| --- | --- | --- |
| enable | Enter privileged EXEC mode | --- |
| configure | Enter configuration mode | Avail in privileged mode only |

Stuff regarding TP-Link's SG3424 series switches

#### Changing the management IP address

The managemet IP address is the VLAN #1 and displayed using `show interface vlan 1`

```
TL-SG3424#show interface vlan 1 

 MAC address:        <Management MAC>
 DHCP client:        Disabled
 BOOTP:              Disabled
 Management VLAN:    1
 -------------------------------------------------------
 IP address:         192.168.0.1
 Subnet Mask:        255.255.255.0
 Gateway:            N/A
```

After adding a new entry in the DHCP server configuration file:
```bash
# Switch TP-Link SG3424
host sw-sg3424 {
  hardware ethernet <Management MAC>;
  fixed-address 172.16.0.10;
  option routers 172.16.0.1;
}
```
Changing the switch management IP address:

```
TL-SG3424>enable
TL-SG3424#configure
TL-SG3424(config)#interface vlan 1
TL-SG3424(config-if)#ip address-alloc dhcp
 Enable DHCP protocol.
 ```
 Checking that the change is effective:
 ```
TL-SG3424#show interface vlan 1 
 MAC address:        <Management MAC>
 DHCP client:        Enabled
 BOOTP:              Disabled
 Management VLAN:    1
 -------------------------------------------------------
 IP address:         172.16.0.10
 Subnet Mask:        255.255.0.0
 Gateway:            172.16.0.1
```

#### Saving settings

Making the changes persistant after a reboot or a power outage.

```
TL-SG3424#copy running-config startup-config
 Start to save user config......

 Saving user config OK!
```
The command takes no more than a few seconds to complete.

#### Setting the SSH enable password


```
TL-SG3424>enable
TL-SG3424#configure
TL-SG3424(config)#enable password <password>
```

Notice this leaves us with two passwords:

* SSH login password matching the user (default admin/admin)
* `enable` command password, required for messing up with the switch
