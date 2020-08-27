FROM haproxy@sha256:22e047e015cb450f3b3541691287296c23f76853de875902699614e83627f003
# FROM haproxy:2.2.2

LABEL LAST_MODIFIED=20200827

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

COPY docker-entrypoint.sh /