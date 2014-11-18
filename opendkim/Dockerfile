FROM debian:wheezy
MAINTAINER Jesse Clark <jjclark1982@gmail.com>

# Install OpenDKIM
RUN set -e; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y opendkim opendkim-tools; \
    rm -rf /var/lib/apt/lists/*

# Configure OpenDKIM
ADD etc /etc/
ADD run-opendkim.sh /

EXPOSE 12301

CMD ["/run-opendkim.sh"]
