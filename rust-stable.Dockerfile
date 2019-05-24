FROM circleci/rust:1.35.0-stretch
USER root

RUN chmod -R a+rwX $RUSTUP_HOME $CARGO_HOME

USER circleci
