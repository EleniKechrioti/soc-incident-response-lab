#!/bin/bash

iptables -F
iptables -X
iptables -Z

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

ATTACKER_IP=172.28.0.10

iptables -A INPUT -p icmp -s $ATTACKER_IP -j LOG --log-prefix "SECURITY ICMP_IN "
iptables -A INPUT -p icmp -s $ATTACKER_IP -j ACCEPT

iptables -A INPUT -p tcp --dport 25 -j LOG --log-prefix "SECURITY SMTP25_IN "

iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -j LOG --log-prefix "SECURITY WEB_OUT "
iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -j ACCEPT

iptables -A INPUT -s $ATTACKER_IP -j LOG --log-prefix "SECURITY ATTACKER_IN "