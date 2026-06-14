#!/bin/bash

# IP address of the attacker node
ATTACKER_IP=172.28.0.10

# Flush existing rules and reset counters
iptables -F
iptables -X
iptables -Z

# Default deny policy
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

# Allow loopback traffic (internal communication)
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow already established and related connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# ICMP (for ping and basic connectivity tests)
iptables -A INPUT -p icmp -s $ATTACKER_IP -j NFLOG --nflog-prefix "SECURITY IDS_ICMP "
iptables -A INPUT -p icmp -s $ATTACKER_IP -j ACCEPT

# Log inbound traffic towards TCP port 25
iptables -A INPUT -p tcp --dport 25 -j NFLOG --nflog-prefix "SECURITY IDS_SMTP25 "

# FTP (port 21)
iptables -A INPUT -p tcp -s $ATTACKER_IP --dport 21 -j NFLOG --nflog-prefix "SECURITY IDS_FTP "
iptables -A INPUT -p tcp -s $ATTACKER_IP --dport 21 -j ACCEPT

# SSH (port 22) - required for brute force attacks (hydra)
iptables -A INPUT -p tcp -s $ATTACKER_IP --dport 22 -j NFLOG --nflog-prefix "SECURITY IDS_SSH "
iptables -A INPUT -p tcp -s $ATTACKER_IP --dport 22 -j ACCEPT

# Telnet (port 23)
iptables -A INPUT -p tcp -s $ATTACKER_IP --dport 23 -j NFLOG --nflog-prefix "SECURITY IDS_TELNET "
iptables -A INPUT -p tcp -s $ATTACKER_IP --dport 23 -j ACCEPT

# HTTP (port 80) - required for web scanning (nikto, nmap -A)
iptables -A INPUT -p tcp -s $ATTACKER_IP --dport 80 -j NFLOG --nflog-prefix "SECURITY IDS_HTTP "
iptables -A INPUT -p tcp -s $ATTACKER_IP --dport 80 -j ACCEPT

# DNS (port 53)
iptables -A INPUT -p udp -s $ATTACKER_IP --dport 53 -j NFLOG --nflog-prefix "SECURITY IDS_DNS "
iptables -A INPUT -p udp -s $ATTACKER_IP --dport 53 -j ACCEPT

# NetBIOS (port 137-139)
iptables -A INPUT -p udp -s $ATTACKER_IP --dport 137:139 -j NFLOG --nflog-prefix "SECURITY IDS_NETBIOS "
iptables -A INPUT -p udp -s $ATTACKER_IP --dport 137:139 -j ACCEPT

# TFTP (port 69)
iptables -A INPUT -p udp -s $ATTACKER_IP --dport 69 -j NFLOG --nflog-prefix "SECURITY IDS_TFTP "
iptables -A INPUT -p udp -s $ATTACKER_IP --dport 69 -j ACCEPT

# Allow outbound HTTP/HTTPS only
iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -j NFLOG --nflog-prefix "SECURITY IDS_WEB_OUT "
iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -j ACCEPT

# Drop all other incoming traffic
iptables -A INPUT -j DROP

# Drop all other outgoing traffic
iptables -A OUTPUT -j DROP