#!/usr/bin/env bash

docker build \
    --tag="possatti/graphite:1.1.5-alpine" \
    - < Dockerfile
