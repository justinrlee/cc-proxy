#!/bin/bash
set -e
set -x

### This is the start of what has been added
if [ -z ${BOOTSTRAP_HOSTNAME} ]; then
	echo "Environment variable BOOTSTRAP_HOSTNAME not set"
	exit 1
fi

if [ -z ${ADMIN_API_HOSTNAME} ]; then
	echo "Environment variable ADMIN_API_HOSTNAME not set"
	exit 1
fi

if [ -z ${CKU_COUNT} ]; then
	echo "Environment variable CKU_COUNT not set"
	exit 1
fi

if [[ ${CKU_COUNT} -eq 1 ]]; then
	BROKER_COUNT=4
else
	BROKER_COUNT=$((CKU_COUNT * 3))
fi

# Two static parts, two dynamic parts.  Like a sandwich.
cp /haproxy_top.cfg /tmp/haproxy_0.cfg
> /tmp/haproxy_1.dcfg
cp /haproxy_middle.cfg /tmp/haproxy_2.cfg
> /tmp/haproxy_3.dcfg

# Generate dynamic files.  This could absolutely be more elegant (seds or multiline strings or something),
# but in this case easier to understand is probably better
for (( b = 0; b < BROKER_COUNT; ++b )); do
    echo "        acl is_broker${b} req.ssl_sni -i b${b}-${BOOTSTRAP_HOSTNAME}" >> /tmp/haproxy_1.dcfg
    echo "        use_backend broker${b} if is_broker${b}" >> /tmp/haproxy_1.dcfg
    echo "" >> /tmp/haproxy_1.dcfg

    echo "backend broker${b}" >> /tmp/haproxy_3.dcfg
    echo "        mode tcp" >> /tmp/haproxy_3.dcfg
    echo "        server broker${b} b${b}-${BOOTSTRAP_HOSTNAME}:9092 check" >> /tmp/haproxy_3.dcfg
    echo "" >> /tmp/haproxy_3.dcfg
done

cat /tmp/haproxy_0.cfg /tmp/haproxy_1.dcfg /tmp/haproxy_2.cfg /tmp/haproxy_3.dcfg > /usr/local/etc/haproxy/haproxy.cfg

sed -i \
	-e "s|ADMIN_API_HOSTNAME|${ADMIN_API_HOSTNAME}|g" \
	-e "s|BOOTSTRAP_HOSTNAME|${BOOTSTRAP_HOSTNAME}|g" \
	/usr/local/etc/haproxy/haproxy.cfg

cat /usr/local/etc/haproxy/haproxy.cfg

### Everything below is copied from the default haproxy docker-entrypoint.sh

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