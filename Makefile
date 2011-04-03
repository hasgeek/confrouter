# Makefile to install conference router configuration

all:
	echo "Usage: sudo make install"

install:
	# Install router
	install -T -m 644 etc/default/router.sh /etc/default/router
	install -T -m 755 etc/init.d/router.sh /etc/init.d/router
	update-rc.d router defaults
	# Install config files
	install --suffix=.orig -b -m 644 etc/network/interfaces /etc/network
	install --suffix=.orig -b -m 644 etc/dnsmasq.conf /etc
	install --suffix=.orig -b -m 644 etc/squid3/squid.conf /etc/squid3
	# Restart services
	/etc/init.d/router restart
	/etc/init.d/dnsmasq restart

uninstall:
	# Restore config files
	mv -f /etc/network/interfaces.orig /etc/network/interfaces
	mv -f /etc/dnsmasq.conf.orig /etc/dnsmasq.conf
	mv -f /etc/squid3/squid.conf.org /etc/squid3/squid.conf
	# Remove router
	/etc/init.d/router stop
	rm -f /etc/default/router
	rm -f /etc/init.d/router
	update-rc.d router remove
	# Restart services
	/etc/init.d/dnsmasq restart
