#!/usr/bin/env sh

rm -f "/usr/bin/crontab"
if [ -e "/usr/bin/crontab.orig" ]; then
  mv "/usr/bin/crontab.orig" "/usr/bin/crontab"
fi

