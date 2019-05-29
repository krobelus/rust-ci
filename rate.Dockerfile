# dep rust-stable
FROM jixone/rust-ci:rust-stable
USER root

RUN cargo install --git https://github.com/krobelus/rate --rev d5095c5f24acee2fabd6d2c8499ad0186ddafcb3

USER circleci
