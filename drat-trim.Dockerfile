FROM circleci/buildpack-deps:stretch
USER root

RUN set -eux; \
    git clone https://github.com/marijnheule/drat-trim; \
    cd drat-trim; \
    make; \
    cp drat-trim /usr/local/bin/; \
    echo installed drat-trim

