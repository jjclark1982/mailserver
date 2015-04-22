#!/bin/sh -e

mkdir -p /var/qmail

addgroup nofiles || true
adduser -SDH -g nofiles -h /var/qmail/alias alias
adduser -SDH -g nofiles -h /var/qmail qmaild
adduser -SDH -g nofiles -h /var/qmail qmaill
adduser -SDH -g nofiles -h /var/qmail qmailp
addgroup qmail
adduser -SDH -g qmail -h /var/qmail qmailq
adduser -SDH -g qmail -h /var/qmail qmailr
adduser -SDH -g qmail -h /var/qmail qmails
