#!/bin/bash

set -eu

CACHING=()

for STEP in $(sed 's/FROM .* as \(.*\)/\1/;t;d' < Dockerfile); do
    docker pull jixone/rust-ci:$STEP || true
    CACHING=(${CACHING[@]} --cache-from jixone/rust-ci:$STEP)

    docker build --target $STEP ${CACHING[@]} -t jixone/rust-ci:$STEP .
    docker push jixone/rust-ci:$STEP
done
