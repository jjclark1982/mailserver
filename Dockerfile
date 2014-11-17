FROM debian:wheezy
MAINTAINER Jesse Clark <jjclark1982@gmail.com>

# Install Postfix, OpenDKIM, SpamAssassin
RUN set -e; \
    echo 'postfix postfix/main_mailer_type string Internet Site'       | debconf-set-selections; \
    echo 'postfix postfix/mynetworks string 172.17.0.0/16 127.0.0.0/8' | debconf-set-selections; \
    echo 'postfix postfix/mailname string HOSTNAME.EXAMPLE.COM'        | debconf-set-selections; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        postfix \
        sasl2-bin \
        opendkim \
        opendkim-tools \
        spamassassin \
        spamc; \
    rm -rf /var/lib/apt/lists/*

ADD assets /
