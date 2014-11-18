FROM debian:wheezy
MAINTAINER Jesse Clark <jjclark1982@gmail.com>

# Install OpenDKIM
RUN set -e; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y dovecot-imapd; \
    rm -rf /var/lib/apt/lists/*
