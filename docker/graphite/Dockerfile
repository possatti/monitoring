# All-in-one graphite image: Carbon + Whisper + Graphite.
# The way I want to do this, is by running a separate container for carbon and
# another one for graphite. Let's see if it works.

FROM alpine:3.9
LABEL maintainer="Lucas Possatti <lucas_possatti@hotmail.com>"

RUN apk --no-cache add \
    cairo \
    gcc \
    libffi-dev \
    logrotate \
    musl-dev \
    py3-pip \
    python3-dev \
    sqlite
# I'm not sure we need logrotate or if carbon and graphite rotate the logs by
# themselves magically.

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

ENV GRAPHITE_ROOT="/opt/graphite"
ENV PATH="${GRAPHITE_ROOT}/bin:${PATH}"

CMD ['echo', 'ERROR! Run each service separately.']
