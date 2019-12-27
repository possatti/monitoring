#!/bin/sh

export GRAPHITE_ROOT="${GRAPHITE_ROOT:-/opt/graphite}"

# From:
#  - https://github.com/graphite-project/docker-graphite-statsd/blob/master/conf/etc/service/graphite/run
export GRAPHITE_WSGI_PROCESSES=${GRAPHITE_WSGI_PROCESSES:-4}
export GRAPHITE_WSGI_THREADS=${GRAPHITE_WSGI_THREADS:-2}
export GRAPHITE_WSGI_REQUEST_TIMEOUT=${GRAPHITE_WSGI_REQUEST_TIMEOUT:-65}
export GRAPHITE_WSGI_REQUEST_LINE=${GRAPHITE_WSGI_REQUEST_LINE:-0}
export GRAPHITE_WSGI_MAX_REQUESTS=${GRAPHITE_WSGI_MAX_REQUESTS:-1000}
export GRAPHITE_WSGI_HOST=${GRAPHITE_WSGI_HOST:-0.0.0.0}
export GRAPHITE_WSGI_PORT=${GRAPHITE_WSGI_PORT:-8080}
export PYTHONPATH="${GRAPHITE_ROOT}/webapp:${GRAPHITE_ROOT}/webapp/graphite"

#django-admin.py migrate --settings=graphite.settings --run-syncdb

if [ ! -d "${GRAPHITE_ROOT}/static/html/" ]; then
    django-admin.py collectstatic --noinput --settings=graphite.settings
fi

gunicorn wsgi --preload \
    --pythonpath=${PYTHONPATH} \
    --workers=${GRAPHITE_WSGI_PROCESSES} \
    --threads=${GRAPHITE_WSGI_THREADS} \
    --limit-request-line=${GRAPHITE_WSGI_REQUEST_LINE} \
    --max-requests=${GRAPHITE_WSGI_MAX_REQUESTS} \
    --timeout=${GRAPHITE_WSGI_REQUEST_TIMEOUT} \
    --bind="${GRAPHITE_WSGI_HOST}:${GRAPHITE_WSGI_PORT}"
    # --log-file=/var/log/gunicorn.log
