#!/bin/sh -e

[ -e /dev/log ] || ln -s /var/run/syslog/log /dev/log

# Copy important files into chroot directory
(cd /etc; cp hosts services resolv.conf /var/spool/postfix/etc/)

daemon_directory=$(postconf -h daemon_directory)

# Kill Postfix if running
$daemon_directory/master -t || postfix stop

# Update and verify config
if [ -z "$maildomain" ]; then
    echo 'Cannot start Postfix because $maildomain is not set'
    exit 1
fi
postconf -e myhostname="$HOSTNAME"
postconf -e myorigin="$HOSTNAME"
postconf -e mydestination="$maildomain localhost.localdomain localhost"
[ -n "$mynetworks" ] && postconf -e mynetworks="$mynetworks"
[ -n "$cert_file" ] && postconf -e smtpd_tls_cert_file="$cert_file"
[ -n "$key_file" ] && postconf -e smtpd_tls_key_file="$key_file"
newaliases
postfix check

# Forward container arguments, signals, and stdio to master daemon.
exec $daemon_directory/master
