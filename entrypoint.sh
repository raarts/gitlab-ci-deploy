#!/bin/sh
set -eu

_should_tls() {
	[ -n "${DOCKER_TLS_CERTDIR:-}" ] \
	&& [ -s "$DOCKER_TLS_CERTDIR/client/ca.pem" ] \
	&& [ -s "$DOCKER_TLS_CERTDIR/client/cert.pem" ] \
	&& [ -s "$DOCKER_TLS_CERTDIR/client/key.pem" ]
}

# if DOCKER_HOST isn't set and we don't have the default unix socket, let's set DOCKER_HOST to a sane remote value
if [ -z "${DOCKER_HOST:-}" ] && [ ! -S /var/run/docker.sock ]; then
	if _should_tls || [ -n "${DOCKER_TLS_VERIFY:-}" ]; then
		export DOCKER_HOST='tcp://docker:2376'
	else
		export DOCKER_HOST='tcp://docker:2375'
	fi
fi
if [ -n "${DOCKER_HOST:-}" ] && _should_tls; then
	export DOCKER_TLS_VERIFY=1
	export DOCKER_CERT_PATH="$DOCKER_TLS_CERTDIR/client"
fi

exec "$@"

