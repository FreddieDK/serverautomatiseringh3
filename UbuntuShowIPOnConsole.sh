echo '#!/bin/sh' >> /etc/networkd-dispatcher/routable.d/add-ip-to-login-screen
echo 'set -e' >> /etc/networkd-dispatcher/routable.d/add-ip-to-login-screen
echo 'HOSTINFO=$(/usr/bin/lsb_release -a 2>&1 | grep Description | /usr/bin/cut -d ":" -f2 | /usr/bin/tr -d [:blank:])' >> /etc/networkd-dispatcher/routable.d/add-ip-to-login-screen
echo 'IPADDRS=$(/usr/sbin/ip -4 -br a)' >> /etc/networkd-dispatcher/routable.d/add-ip-to-login-screen
echo '/usr/bin/echo -ne "Host OS: $HOSTINFO\n$IPADDRS\n" > /etc/issue' >> /etc/networkd-dispatcher/routable.d/add-ip-to-login-screen
chmod +x /etc/networkd-dispatcher/routable.d/add-ip-to-login-screen
reboot