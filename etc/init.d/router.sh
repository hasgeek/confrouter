#! /bin/sh
### BEGIN INIT INFO
# Provides:          router
# Required-Start:    $remote_fs $syslog dnsmasq
# Required-Stop:     $dnsmasq
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start router at boot time
# Description:       Enables NAT on the downstream network interface
### END INIT INFO

#
# router	This script sets up the slug as a dialup router.
#		It is called from the boot, halt and reboot scripts.
#
# Version:	@(#)router  0.1  03-Sep-2009  jace@pobox.com
#

. /etc/default/rcS
. /etc/default/router

mknod /dev/ttyUSB0 c 188 1 2> /dev/null
mknod /dev/ttyUSB1 c 188 2 2> /dev/null
mknod /dev/ttyUSB2 c 188 3 2> /dev/null
mknod /dev/ttyUSB3 c 188 4 2> /dev/null

case "$1" in
	start)
		test "$VERBOSE" != no && echo "Initializing iptables..."
		iptables --flush
		iptables --table nat --flush
		iptables --delete-chain
		iptables --table nat --delete-chain

		iptables --table nat --append POSTROUTING -j MASQUERADE
		iptables --append FORWARD --in-interface $DOWNSTREAM_IFACE -j ACCEPT
		iptables -A FORWARD -p tcp --dport 6881:7000  -j DROP
		iptables -A FORWARD -p tcp --dport 2710 -j DROP

		echo 1 > /proc/sys/net/ipv4/ip_forward

		;;
	stop)
		test "$VERBOSE" != no && echo "Shutting down iptables..."
		iptables --flush
		iptables --table nat --flush
		iptables --delete-chain
		iptables --table nat --delete-chain

		echo 0 > /proc/sys/net/ipv4/ip_forward

		;;
        restart)
                $0 stop
                $0 start
                ;;
	*)
		echo "Usage: router {start|stop}" >&2
		exit 1
		;;
esac

exit 0
