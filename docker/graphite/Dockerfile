# All-in-one graphite image: Carbon + Whisper + Graphite.
# The way I want to do this, is by running a separate container for carbon and
# another one for graphite. Let's see if it works.

FROM alpine:3.9
LABEL maintainer="Lucas Possatti <lucas_possatti@hotmail.com>"

RUN apk --no-cache add \
    python3-dev \
    libffi-dev \
    musl-dev \
    py3-pip \
    gcc

# logrotate should be useful.

# Install graphite and fellas.
# Things will get installed to '/opt/graphite'.
ARG version=1.1.5
ARG carbon_version=${version}
ARG whisper_version=${version}
ARG graphite_version=${version}
RUN pip3 install \
    carbon==${carbon_version} \
    whisper==${whisper_version} \
    graphite-web==${graphite_version}

ARG gunicorn_version=19.9.0
RUN pip3 install gunicorn==${gunicorn_version}
RUN apk --no-cache add sqlite
RUN apk --no-cache add cairo

ENV PATH="/opt/graphite/bin:${PATH}"
ENV GRAPHITE_ROOT="/opt/graphite"

# PYTHONPATH=/opt/graphite/webapp /opt/graphite/bin/django-admin.py collectstatic --noinput --settings=graphite.settings

CMD ['echo', 'Run each service separately.']
