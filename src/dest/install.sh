#!/usr/bin/env sh

if [ -e "/usr/bin/crontab" ]; then
  mv "/usr/bin/crontab" "/usr/bin/crontab.orig"
fi

prog_dir="$(dirname "$(realpath "${0}")")"
ln -s "${prog_dir}/bin/crontab" "/usr/bin/crontab"
