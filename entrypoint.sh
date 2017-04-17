#!/bin/sh

# Starting Bind Server
/usr/sbin/service bind9 start

# Start Webmin Service 
/usr/bin/touch /var/webmin/miniserv.log && /usr/sbin/service webmin restart && /usr/bin/tail -f /var/webmin/miniserv.log

# End