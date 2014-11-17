#!/bin/sh

[ -e /dev/log ] || ln -s /var/run/syslog/log /dev/log

cat > /etc/opendkim/TrustedHosts <<EOF
127.0.0.1
localhost
192.168.0.1/24
172.17.0.0/16
EOF

rm /etc/opendkim/KeyTable
rm /etc/opendkim/SigningTable


DOMAINS=$(find /etc/ssl/private -iname '*.private' \
    | sed -r 's:^/etc/ssl/private/(mail\.)?(.*)\.private$:\2:')

for DOMAIN in $DOMAINS; do

cat >> /etc/opendkim/TrustedHosts <<EOF
*.$DOMAIN
EOF

cat >> /etc/opendkim/KeyTable <<EOF
mail._domainkey.$DOMAIN $DOMAIN:mail:$(echo /etc/ssl/private/*$DOMAIN.private)
EOF

cat >> /etc/opendkim/SigningTable <<EOF
*@$DOMAIN mail._domainkey.$DOMAIN
EOF

done

exec opendkim -f "$@"
