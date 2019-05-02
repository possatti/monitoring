FROM alpine:3.9

RUN apk --no-cache add \
    python \
    python-dev \
    py-pip

# TODO: Squash.
RUN apk --no-cache add \
    gcc

# TODO: Squash.
RUN apk --no-cache add \
    musl-dev

RUN pip install carbon

CMD ['/opt/graphite/bin/carbon-cache.py']

# Build succeeds, but couldn't get carbon to work yet.

# Stuff is in /opt/graphite. Could I get it elsewhere, maybe with
# GRAPHITE_NO_PREFIX=True python setup.py install