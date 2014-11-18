#!/bin/sh -e

[ -e /dev/log ] || ln -s /var/run/syslog/log /dev/log

exec spamd
