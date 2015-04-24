FROM gliderlabs/alpine:3.1

RUN apk-install gcc groff libc-dev libgcc make
# RUN apk-install binutils clang groff libc-dev libgcc make
# RUN ln -s /usr/bin/clang /usr/bin/cc

ADD ./create-users.sh /tmp/create-users.sh
RUN /tmp/create-users.sh

# compile qmail
RUN set -e; \
mkdir -p /usr/local/src; \
cd /usr/local/src; \
echo 'c922f776140b2c83043a6195901c67d3  netqmail-1.06.tar.gz' >> md5sums.txt; \
wget -q http://www.qmail.org/netqmail-1.06.tar.gz; \
md5sum -c md5sums.txt; \
tar xzf netqmail-1.06.tar.gz; \
cd netqmail-1.06/; \
make setup check

# compile ucspi-tcp
RUN set -e; \
mkdir -p /usr/local/src; \
cd /usr/local/src; \
echo '39b619147db54687c4a583a7a94c9163  ucspi-tcp-0.88.tar.gz' >> md5sums.txt; \
wget -q http://cr.yp.to/ucspi-tcp/ucspi-tcp-0.88.tar.gz; \
md5sum -c md5sums.txt; \
tar xzf ucspi-tcp-0.88.tar.gz; \
cd ucspi-tcp-0.88/; \
patch < /usr/local/src/netqmail-1.06/other-patches/ucspi-tcp-0.88.errno.patch; \
make; \
make setup check

# compile daemontools
RUN set -e; \
mkdir -p /package; \
cd /package; \
echo '1871af2453d6e464034968a0fbcb2bfc  daemontools-0.76.tar.gz' >> md5sums.txt; \
wget -q http://cr.yp.to/daemontools/daemontools-0.76.tar.gz; \
md5sum -c md5sums.txt; \
tar xzf daemontools-0.76.tar.gz; \
cd admin/daemontools-0.76; \
(cd src; patch < /usr/local/src/netqmail-1.06/other-patches/daemontools-0.76.errno.patch); \
./package/install

RUN /usr/local/src/netqmail-1.06/config-fast MAIL.EXAMPLE.COM

CMD ["tar", "c", "/var/qmail"]
