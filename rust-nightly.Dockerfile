# dep rust-stable
FROM jixone/rust-ci:rust-stable
USER root

RUN rustup toolchain install nightly; \
    chmod -R a+rwX $RUSTUP_HOME $CARGO_HOME

USER circleci
