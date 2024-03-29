# born2beroot
### Operating system
Debian 11.6

## Requirements
- [X] No graphical interface

- [X] 2 encrypted partitions using LVM

- [X] SSH service only running on port 4242

- [X] Impossible to connect using SSH as root

- [X] Configure operating system with the UFW

### hostname
- [X] Login ending with 42

### Users
- [X] Root user

- [X] A user with the login as username, it has to belong to the user42 and sudo groups

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
- [X] Authentication of sudo caused by incorrect password is limited to 3 attempts.

- [X] Display message if there is an error caused by an incorrect password.

- [X] Archive every action of sudo (inputs and outputs). The log file has to be saved in: /var/log/sudo/

- [X] TTY mode has to be enabled

- [X] Paths that can be used by sudo must be restricted.

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
echo '224cd...e6f51  debian-11.6.0-amd64-netinst.iso' | sha512sum --check
debian-11.6.0-amd64-netinst.iso: OK
```
### monitoring script
```bash
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    monitoring.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: echavez- <echavez-@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/01/31 12:22:02 by echavez-          #+#    #+#              #
#     Updated: 2023/01/31 12:26:44 by echavez-         ###   ########.fr       #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

function ft_ram()
{
    # RAM INFO

    ## Variables
    local _free=$(free -m | grep Mem | awk '{print $3}')
    local _total=$(free -m | grep Mem | awk '{print $2}')
    local _usage_percent=$(free -m | grep Mem | awk '{printf("%.2f"), $3 / $2 * 100}')

    ## Return formated info
    echo "${_free}/${_total}MB (${_usage_percent}%)"
}

function ft_mem()
{
    # DISK MEMORY INFO

    ## Disk description lines
    local _mem_mb=$(df -Bm | grep '^/dev/' | grep -v '/boot$') # megas
    local _mem_gb=$(df -Bg | grep '^/dev/' | grep -v '/boot$') # gigas

    ## Variables
    local _free=$(echo "$_mem_mb" | awk '{free_mem += $4} END {print free_mem}')
    local _total=$(echo "$_mem_gb" | awk '{total_mem += $2} END {print total_mem}')
    local _usage_percent=$(echo "$_mem_mb" | awk '{used_mem += $3} {total_mem += $2} END \
    	  		      	       	      {printf("%.2f"), used_mem / total_mem * 100}')

    ## Return formated info
    echo "${_free}/${_total}GB (${_usage_percent}%)"
}

architecture=$(uname -a)
phy_proc=$(grep "^physical id" /proc/cpuinfo | sort -u | wc -l)
vir_proc=$(grep "^processor" /proc/cpuinfo | wc -l)
av_ram=$(ft_ram)
av_mem=$(ft_mem)
cpu_load=$()
last_reboot=$()
lvm_active=$(lsblk | grep -m1 lvm | awk '{if ($1) {print "yes"} else {print "no"} }')
active_connections=$()
active_users=$()
ip_mac=$()
sudo_commands=$(sudo grep 'sudo:session' /var/log/auth.log | grep -v 'session closed\|COMMAND' | wc -l)

wall "    #Architecture: $architecture
    #CPU physical: $phy_proc
    #vCPU: $vir_proc
    #Memory Usage: $av_ram
    #Disk Usage: $av_mem
    #CPU Load: $cpu_load
    #Last boot: $last_reboot
    #LVM use: $lvm_active
    #Connections TCP: $active_connections
    #User log: $active_users
    #Network: $ip_mac
    #Sudo: $sudo_commands cmd"
```
