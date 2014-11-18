#!/bin/sh

[ -e /dev/log ] || ln -s /var/run/syslog/log /dev/log

cat >> /etc/opendkim/TrustedHosts <<EOF
127.0.0.1
localhost
192.168.0.1/24
*.$maildomain
EOF

cat >> /etc/opendkim/KeyTable <<EOF
mail._domainkey.$maildomain $maildomain:mail:$(find /etc/ssl/private -iname *.private)
EOF

cat >> /etc/opendkim/SigningTable <<EOF
*@$maildomain mail._domainkey.$maildomain
EOF

exec opendkim -f "$@"
