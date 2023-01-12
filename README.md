# born2beroot
### Operating system
Debian 11

## Requirements
- No graphical interface

- 2 encrypted partitions using LVM

- SSH service only running on port 4242

- Impossible to connect using SSH as root

- Configure operating system with the UFW

### hostname
- [ ] Login ending with 42

### Users
- [ ] Root user

* A user with the login as username, it has to belong to the user42 and sudo groups

### pwd security
|Requirements |Description  |
|--- | --- |
| **Expiration**|Every 30 days|
| **Min number of days allowed before modification** |2|
| **Warning message**|7 days before expiration|
| **Length**|At least 10 characters|
| **Composition**|An uppercase letter, a lowercase letter and a number|
| **Forbidden**|More than 3 consecutive identical characters, include the name of the user|
| **New password**|Must have at least 7 characters that aren't a part of the former password|

### Configuration for sudo group
Authentication of sudo caused by incorrect password is limited to 3 attempts.

Display message if there is an error caused by an incorrect password.

Archive every action of sudo (inputs and outputs). The log file has to be saved in: /var/log/sudo/

TTY mode has to be enabled

Paths that can be used by sudo must be restricted.

### monitoring.sh

Developed in bash, will display some information on all terminals every 10 min. No error must be visible.

|Information for the script|
| --- |
|The architecture of your operating system and its kernel version|
|Number of physical processors|
|Number of virtual processors|
|Current available RAM on your server and its utilization rate as a percentage|
|Current available memory on your server and its utilization rate as a percentage|
|Current utilization rate of your processors as a percentage|
|Date and time of the last reboot|
|Whether LVM is active or not|
|Number of active connections|
|Number of users using the server|
| IPv4 address of your server and its MAC address|
| Number of commands executed with the sudo program.|

### Steps
* Download and check debian distro:
```bash
echo '224cd98011b9184e49f858a46096c6ff4894adff8945ce89b194541afdfd93b73b4666b0705234bd4dff42c0a914fdb6037dd0982efb5813e8a553d8e92e6f51  debian-11.6.0-amd64-netinst.iso' | sha512sum --check
debian-11.6.0-amd64-netinst.iso: OK
```

