# dep rust-stable
FROM jixone/rust-ci:rust-stable
USER root

RUN set -eu; \
    wget https://github.com/tcnksm/ghr/releases/download/v0.12.1/ghr_v0.12.1_linux_amd64.tar.gz; \
    tar xzf ghr_v0.12.1_linux_amd64.tar.gz; \
    cp ghr_v0.12.1_linux_amd64/ghr /usr/local/bin; \
    rm -r ghr_v0.12.1_linux_amd64 ghr_v0.12.1_linux_amd64.tar.gz

USER circleci
