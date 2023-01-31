# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    monitoring.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: echavez- <echavez-@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/01/31 12:22:02 by echavez-          #+#    #+#              #
#    Updated: 2023/01/31 12:22:12 by echavez-         ###   ########.fr        #
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
