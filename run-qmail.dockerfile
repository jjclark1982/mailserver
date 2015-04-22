FROM gliderlabs/alpine:3.1

ADD ./create-users.sh /tmp/
RUN /tmp/create-users.sh

ADD ./qmail.tar /
