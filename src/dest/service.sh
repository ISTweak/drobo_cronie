#!/usr/bin/env sh
#
# crond service

# import DroboApps framework functions
. /etc/service.subr

name="cronie"
version="1.4.12"
description="Crond scheduler service"

prog_dir=`dirname \`realpath $0\``
pidfile=${prog_dir}/var/run/${name}.pid
syscrond="${prog_dir}/etc/cron.d"
spooldir="${prog_dir}/var/spool/cron"

start() {
	if [[ ! -d "${syscrond}" ]]; then mkdir -p "${syscrond}"; fi
	if [[ ! -d "${spooldir}" ]]; then mkdir -p "${spooldir}"; fi
	if [[ ! -d "${prog_dir}/var/run" ]]; then mkdir -p "${prog_dir}/var/run"; fi

	${prog_dir}/sbin/crond
	echo `/bin/pidof -s crond` > ${pidfile}
}

_mk_link() {
	if [ -e "/usr/bin/crontab" ]; then 
		if [ ! -e "/usr/bin/crontab.orig" ]; then
			mv "/usr/bin/crontab" "/usr/bin/crontab.orig"
		else
			rm -f "/usr/bin/crontab"
		fi
	fi

	ln -s "${prog_dir}/bin/crontab" "/usr/bin/crontab"
}

_rm_link() {
	rm -f "/usr/bin/crontab"
	if [ -e "/usr/bin/crontab.orig" ]; then
		mv "/usr/bin/crontab.orig" "/usr/bin/crontab"
	else
		ln -s "bin/busybox" "/usr/bin/crontab"
	fi
}

stop() {
	stop_service
}

case "$1" in
start)
		_mk_link
        start_service
        ;;
stop)
        stop_service
		_rm_link
        ;;
restart)
        stop_service
        sleep 3
        start_service
        ;;
status)
        status
        ;;
*)
        echo "Usage: $0 [start|stop|restart|status]"
        exit 1
        ;;
esac

