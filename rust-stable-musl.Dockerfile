# dep rust-stable
FROM jixone/rust-ci:rust-stable
USER root

RUN set -eux; \
    apt-get install -y musl musl-dev musl-tools; \
    rustup target add x86_64-unknown-linux-musl; \
    chmod -R a+rwX $RUSTUP_HOME $CARGO_HOME

USER circleci
