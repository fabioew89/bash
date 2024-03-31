#!/usr/bin/env bash

username="fabio.ewerton"
device_model="DM4360"
command="show running-config hostname ;\
         show platform ; \
         sh running-config lldp"

# host_ip=$(seq -f "100.127.0.%g" 0 10)

for ip_host in 100.127.0.{60..79}; do
    if ping -c 3 -q -W 3 "$ip_host" > /dev/null; then
        ssh_output=$(sshpass -f password ssh -o StrictHostKeyChecking=no "$username"@"$ip_host" "$command")
        get_device_hostname=$(echo "$ssh_output" | grep -i hostname | cut -d ' ' -f 2)
        get_device_model=$(echo "$ssh_output" | awk 'NR==4 { print $2 }')
        get_device_lldp=$(echo "$ssh_output" | awk '/lldp/,0')

        echo -e "\e[32m\n[INFO] - Geting information about "$get_device_hostname" - "$ip_host"\e[0m"
    else
        echo -e "\e[31m\n[INFO] - Sorry, better luck next time "$ip_host"\e[0m"
    fi

    # JUST SEPARATOR
    echo
    for _ in $( seq 15 ); do
        echo -n "##### "
    done
    echo   
done