FROM debian:wheezy
MAINTAINER Jesse Clark <jjclark1982@gmail.com>

# Install Spam Assassin
RUN set -e; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y spamassassin; \
    rm -rf /var/lib/apt/lists/*

ADD etc /etc/
ADD run-spamd.sh /

EXPOSE 783

CMD ["/run-spamd.sh"]
