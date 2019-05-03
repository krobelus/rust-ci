FROM circleci/rust:1.34.1-stretch as rust-stable
USER root

RUN chmod -R a+rwX $RUSTUP_HOME $CARGO_HOME

USER circleci



FROM rust-stable as rust-nightly
USER root

RUN rustup toolchain install nightly; \
    chmod -R a+rwX $RUSTUP_HOME $CARGO_HOME

USER circleci



FROM rust-stable as rust-stable-musl
USER root

RUN set -eux; \
    apt-get install -y musl musl-dev musl-tools; \
    rustup target add x86_64-unknown-linux-musl; \
    chmod -R a+rwX $RUSTUP_HOME $CARGO_HOME

USER circleci



FROM rust-stable as rust-stable-mingw
USER root

RUN set -eux; \
    apt-get install -y gcc-mingw-w64-x86-64; \
    echo '[target.x86_64-pc-windows-gnu]' >> $CARGO_HOME/config; \
    echo 'linker = "x86_64-w64-mingw32-gcc"' >> $CARGO_HOME/config; \
    echo 'ar = "x86_64-w64-mingw32-gcc-ar"' >> $CARGO_HOME/config; \
    rustup target add x86_64-pc-windows-gnu; \
    chmod -R a+rwX $RUSTUP_HOME $CARGO_HOME

USER circleci



FROM rust-stable as build-mdbook
USER root

RUN cargo install mdbook



FROM rust-stable as mdbook

COPY --from=build-mdbook /usr/local/cargo/bin/mdbook /usr/local/cargo/bin/mdbook




FROM circleci/buildpack-deps:stretch as check-lrat
USER root

RUN set -eux; \
    wget https://downloads.sourceforge.net/project/sbcl/sbcl/1.5.1/sbcl-1.5.1-x86-64-linux-binary.tar.bz2; \
    tar xjf sbcl-1.5.1-x86-64-linux-binary.tar.bz2; \
    cd sbcl-1.5.1-x86-64-linux; \
    sh install.sh; \
    cd ..; \
    rm -r sbcl-1.5.1-x86-64-linux-binary.tar.bz2 sbcl-1.5.1-x86-64-linux; \
    echo installed sbcl

RUN set -eux; \
    wget https://github.com/acl2-devel/acl2-devel/releases/download/8.1/acl2-8.1.tar.gz; \
    tar xzf acl2-8.1.tar.gz; \
    cd acl2-8.1; \
    make -j$(nproc) LISP=sbcl; \
    cd books; \
    make -j$(nproc) ACL2=$PWD/../saved_acl2 projects/sat/lrat/stobj-based/run.cert; \
    make -j$(nproc) ACL2=$PWD/../saved_acl2 projects/sat/lrat/incremental/run.cert; \
    echo -e '(include-book "projects/sat/lrat/stobj-based/run" :dir :system)\n:q\n(save-exec "/usr/local/bin/check-lrat" nil :host-lisp-args "--dynamic-space-size 240000")' | ../saved_acl2; \
    echo -e '(include-book "projects/sat/lrat/incremental/run" :dir :system)\n:q\n(save-exec "/usr/local/bin/check-clrat" nil :host-lisp-args "--dynamic-space-size 240000")' | ../saved_acl2; \
    echo installed check-lrat



FROM circleci/buildpack-deps:stretch as kcov
USER root

RUN set -eux; \
    apt-get install -y cmake binutils-dev libelf-dev libdw-dev; \
    git clone https://github.com/jix/kcov; \
    cd kcov; \
    git checkout no-disable-aslr; \
    mkdir build; \
    cd build; \
    cmake ..; \
    make -j$(nproc); \
    make DESTDIR=/install install; \
    echo installed kcov



FROM circleci/buildpack-deps:stretch as drat-trim
USER root

RUN set -eux; \
    git clone https://github.com/marijnheule/drat-trim; \
    cd drat-trim; \
    make; \
    cp drat-trim /usr/local/bin/; \
    echo installed drat-trim



FROM circleci/buildpack-deps:stretch as varisat-tests
USER root

RUN apt-get install -y libdw1

COPY --from=kcov \
    /install/ \
    /

COPY --from=check-lrat \
    /usr/local/bin/sbcl \
    /usr/local/bin/check-lrat \
    /usr/local/bin/check-lrat.core \
    /usr/local/bin/check-clrat \
    /usr/local/bin/check-clrat.core \
    /usr/local/bin/

COPY --from=drat-trim /usr/local/bin/drat-trim /usr/local/bin/

USER circleci
