#!/bin/sh
set -e

### This is the start of what has been added
if [ -z ${BOOTSTRAP_HOSTNAME} ]; then
echo "Environment variable BOOTSTRAP_HOSTNAME not set"
exit 1
fi

sed -i "s|BOOTSTRAP_HOSTNAME|${BOOTSTRAP_HOSTNAME}|g" /usr/local/etc/haproxy/haproxy.cfg

cat /usr/local/etc/haproxy/haproxy.cfg

### Everything below is the default haproxy docker-entrypoint.sh

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- haproxy "$@"
fi

if [ "$1" = 'haproxy' ]; then
	shift # "haproxy"
	# if the user wants "haproxy", let's add a couple useful flags
	#   -W  -- "master-worker mode" (similar to the old "haproxy-systemd-wrapper"; allows for reload via "SIGUSR2")
	#   -db -- disables background mode
	set -- haproxy -W -db "$@"
fi

exec "$@"