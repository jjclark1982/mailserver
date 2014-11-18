FROM debian:wheezy
MAINTAINER Jesse Clark <jjclark1982@gmail.com>

# # Install daemontools to supervise the daemon
# RUN set -e; \
#     apt-get update; \
#     apt-get install -y daemontools; \
#     rm -rf /var/lib/apt/lists/*

# Install Postfix
RUN set -e; \
    echo 'postfix postfix/main_mailer_type string Internet Site'       | debconf-set-selections; \
    echo 'postfix postfix/mynetworks string 172.17.0.0/16 127.0.0.0/8' | debconf-set-selections; \
    echo 'postfix postfix/mailname string HOSTNAME.EXAMPLE.COM'        | debconf-set-selections; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y postfix sasl2-bin spamc; \
    rm -rf /var/lib/apt/lists/*

# Configure for OpenDKIM
RUN set -e; \
    postconf -e milter_protocol=2; \
    postconf -e milter_default_action=accept; \
    postconf -e smtpd_milters=inet:opendkim:12301; \
    postconf -e non_smtpd_milters=inet:opendkim:12301

# Configure for spamassassin
RUN set -e; \
    sed -i -r 's/^(smtp.*smtpd)$/\1 -o content_filter=spamassassin/'         /etc/postfix/master.cf; \
    echo 'spamassassin unix -     n       n       -       -       pipe'   >> /etc/postfix/master.cf; \
    echo '        user=postfix argv=/usr/bin/spamc -d spamassassin'       >> /etc/postfix/master.cf; \
    echo '        -e /usr/sbin/sendmail -oi -f ${sender} ${recipient}'    >> /etc/postfix/master.cf

    # ln -s /var/run/syslog/log /dev/log;
#    rm /etc/aliases
#    cp /etc/aliases /etc/postfix/aliases; \
#    ln -s /etc/postfix/aliases /etc/aliases
#    postconf -e alias_maps=hash:/etc/postfix/aliases; \
#    postconf -e alias_database=hash:/etc/postfix/aliases;

# need to configure main.cf with spam service
# and etc/services with
# spamassassin unix -     n       n       -       -       pipe
#   user=debian-spamd argv=/usr/bin/spamc -d spamassassin -f -e /usr/sbin/sendmail -oi -f ${sender} ${recipient}


# Create the init script
ADD run-postfix.sh /

EXPOSE 25 465 587

# Support backing up in-progress mails
VOLUME /var/spool/postfix

# # may not need this if we can get everything in by env
# VOLUME /etc/postfix

CMD ["/run-postfix.sh"]
