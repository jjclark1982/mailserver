FROM gliderlabs/alpine:3.1

RUN apk-install gcc groff libc-dev libgcc make
# RUN apk-install binutils clang groff libc-dev libgcc make
# RUN ln -s /usr/bin/clang /usr/bin/cc

ADD ./create-users.sh /tmp
RUN /tmp/create-users.sh

RUN set -e; \
mkdir -p /usr/local/src; \
cd /usr/local/src; \
echo 'c922f776140b2c83043a6195901c67d3  netqmail-1.06.tar.gz' > md5sums.txt; \
wget -q http://www.qmail.org/netqmail-1.06.tar.gz; \
md5sum -c md5sums.txt; \
tar xzf netqmail-1.06.tar.gz; \
cd netqmail-1.06/; \
make setup check

CMD ["tar", "c", "/var/qmail"]
