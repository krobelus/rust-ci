FROM circleci/rust:1.34.1-stretch
USER root

RUN chmod -R a+rwX $RUSTUP_HOME $CARGO_HOME

USER circleci
