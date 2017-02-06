#!/usr/bin/env sh
#
# crond service

# import DroboApps framework functions
. /etc/service.subr

# DroboApp framework version
framework_version="2.1"

# app description
name="cronie"
version="1.4.12"
description="Crond scheduler service"

# framework-mandated variables
pidfile="/tmp/DroboApps/${name}/pid.txt"
logfile="/tmp/DroboApps/${name}/log.txt"
statusfile="/tmp/DroboApps/${name}/status.txt"
errorfile="/tmp/DroboApps/${name}/error.txt"

# app-specific variables
prog_dir=$(dirname $(readlink -fn ${0}))
daemon="${prog_dir}/sbin/crond"
syscrond="${prog_dir}/etc/cron.d"
spooldir="${prog_dir}/var/spool/cron"

# ensure log folder exists
logfolder="$(dirname ${logfile})"
if [[ ! -d "${logfolder}" ]]; then mkdir -p "${logfolder}"; fi

# redirect all output to logfile
exec 3>&1 1>> "${logfile}" 2>&1

# log current date, time, and invocation parameters
echo $(date +"%Y-%m-%d %H-%M-%S"): ${0} ${@}

# _is_running
# args: path to pid file
# returns: 0 if pid is running, 1 if not running or if pidfile does not exist.
_is_running() {
  /sbin/start-stop-daemon -K -v -s 0 -x "${daemon}" -q
}

start_service() {
  if [[ ! -d "${syscrond}" ]]; then mkdir -p "${syscrond}"; fi
  if [[ ! -d "${spooldir}" ]]; then mkdir -p "${spooldir}"; fi

  /sbin/start-stop-daemon -S -v -x "${daemon}" -m -p "${pidfile}" -N 10
}

_service_start() {
  set +e
  set +u
  if _is_running ; then
    echo ${name} is already running >&3
    return 1
  fi
  start_service
  set -u
  set -e
}

_service_stop() {
  /sbin/start-stop-daemon -K -v -x "${daemon}"
  rm -f "${pidfile}"
}

_service_restart() {
  service_stop
  sleep 3
  service_start
}

_service_status() {
  status >&3
}

_service_help() {
  echo "Usage: $0 [start|stop|restart|status]" >&3
  set +e
  exit 1
}

case "${1:-}" in
  start|stop|restart|status) _service_${1} ;;
  *) _service_help ;;
esac

