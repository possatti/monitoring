#!/bin/sh


## I was having issues with carbon cache. At times it would die, but left the pid file.
## When docker tries to restart it, carbon says it's already running because of the pid
## file, even though it's not.
rm -f ${GRAPHITE_ROOT}/storage/*.pid

/opt/graphite/bin/carbon-cache.py --nodaemon start

