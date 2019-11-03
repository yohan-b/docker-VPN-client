#!/bin/bash
function openvpn_is_dead() {
        ping -n 8.8.8.8 -c 1 -w 3 >/dev/null 2>&1 && ifconfig tun0 >/dev/null 2>&1
        r=$((! $? ))
        return $r
}
function stop_openvpn() {
        pkill -TERM openvpn
        sleep 2
        pkill -KILL openvpn
        sleep 1
}
function start_openvpn {
        openvpn --daemon --config /etc/openvpn/openvpn.conf
}
# stop service and clean up here
function shut_down() {
stop_openvpn
reset
echo "exited $0"
exit 0
}

# USE the trap if you need to also do manual cleanup after the service is stopped,
#     or need to start multiple services in the one container
trap "shut_down" SIGINT SIGTERM SIGKILL

# start service in background here
start_openvpn
sleep 3
iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
# L2TP route
ip route add 192.168.2.0/24 via 172.31.1.3 dev eth0
#ip route add 192.168.1.0/24 via 192.168.2.1 dev eth0
#bash

while true
do
        sleep 60
        if openvpn_is_dead
        then 
                stop_openvpn
                start_openvpn
        fi
done

shut_down

