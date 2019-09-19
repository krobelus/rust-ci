# dep rust-stable
FROM jixone/rust-ci:rust-stable
USER root

RUN cargo install rate

USER circleci
