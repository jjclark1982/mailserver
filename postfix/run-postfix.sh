#!/bin/sh -e

cp /etc/hosts /var/spool/postfix/etc/hosts
cp /etc/services /var/spool/postfix/etc/services
cp /etc/resolv.conf /var/spool/postfix/etc/resolv.conf
[ -e /dev/log ] || ln -s /var/run/syslog/log /dev/log

daemon_directory=$(postconf -h daemon_directory)

# Kill Postfix if running
$daemon_directory/master -t || postfix stop

# Update and verify config
[ -n "$maildomain" ] && postconf -e myhostname="$maildomain"
[ -n "$maildomain" ] && postconf -e myorigin="$maildomain"
[ -n "$mydestination" ] && postconf -e mydestination="$mydestination"
[ -n "$mynetworks" ] && postconf -e mynetworks="$mynetworks"
[ -n "$cert_file" ] && postconf -e smtpd_tls_cert_file="$cert_file"
[ -n "$key_file" ] && postconf -e smtpd_tls_key_file="$key_file"
newaliases
postfix check

# Forward container arguments, signals, and stdio to master daemon.
exec $daemon_directory/master "$@"
