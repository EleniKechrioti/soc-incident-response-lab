#!/bin/bash

# 1. Δημιουργία φακέλων logs (το -p φτιάχνει και τους υποφακέλους)
mkdir -p /var/log/lab/suricata

# 2. Ξεκίνημα ulogd2
service ulogd2 start
bash /opt/victim/scripts/firewall_ids.sh

# 3. Ρύθμιση rsyslog
echo "*.* /var/log/lab/syslog.log" > /etc/rsyslog.d/50-lab.conf
echo "kern.* /var/log/lab/kern.log" >> /etc/rsyslog.d/50-lab.conf

# 4. Δικαιώματα (Δίνουμε παντού στο /var/log/lab για να τελειώνουμε)
touch /var/log/lab/syslog.log
touch /var/log/lab/kern.log
chown -R syslog:adm /var/log/lab
chmod -R 775 /var/log/lab

# 5. Τρέχουμε rsyslog
rm -f /run/rsyslogd.pid
/usr/sbin/rsyslogd

# 6. Υπηρεσίες
service ssh start
nginx -g 'daemon off;' &

# 7. Εκκίνηση Suricata (Προσθέτουμε ένα sleep για να σιγουρευτούμε ότι το interface είναι έτοιμο)
sleep 2
pkill suricata || true
rm -f /var/run/suricata.pid
suricata -D -c /etc/suricata/suricata.yaml -i eth0 -k none

# 8. Output για το docker logs
tail -f /var/log/lab/syslog.log