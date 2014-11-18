FROM debian:wheezy

# Install rsyslog
RUN set -e; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y rsyslog; \
    rm -rf /var/lib/apt/lists/*

VOLUME /var/log
VOLUME /var/run/syslog
VOLUME /var/spool/postfix/dev

# Config file that creates sockets in the mounted dirs and directs output to container stdio
ADD etc /etc/

CMD ["rsyslogd", "-n", "-c5"]
