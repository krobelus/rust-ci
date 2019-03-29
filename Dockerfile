FROM circleci/buildpack-deps:stretch

USER root

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN set -eux; \
    curl https://sh.rustup.rs -sSf > rustup-init; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --default-toolchain stable; \
    rm rustup-init; \
    rustup toolchain install nightly; \
    RUSTFLAGS="--cfg procmacro2_semver_exempt" cargo +nightly install cargo-tarpaulin; \
    rustup --version >> /etc/rust-versions; \
    cargo --version >> /etc/rust-versions; \
    rustc --version >> /etc/rust-versions; \
    cargo +nightly --version >> /etc/rust-versions; \
    rustc +nightly --version >> /etc/rust-versions; \
    cargo tarpaulin --version >> /etc/rust-versions; \
    chmod -R a+rwX $RUSTUP_HOME $CARGO_HOME;

USER circleci
