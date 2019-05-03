# dep rust-stable
FROM jixone/rust-ci:rust-stable
USER root

RUN set -eux; \
    apt-get install -y gcc-mingw-w64-x86-64; \
    echo '[target.x86_64-pc-windows-gnu]' >> $CARGO_HOME/config; \
    echo 'linker = "x86_64-w64-mingw32-gcc"' >> $CARGO_HOME/config; \
    echo 'ar = "x86_64-w64-mingw32-gcc-ar"' >> $CARGO_HOME/config; \
    rustup target add x86_64-pc-windows-gnu; \
    chmod -R a+rwX $RUSTUP_HOME $CARGO_HOME

USER circleci
