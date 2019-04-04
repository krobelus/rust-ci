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
    rustup --version >> /etc/rust-versions; \
    cargo --version >> /etc/rust-versions; \
    rustc --version >> /etc/rust-versions; \
    cargo +nightly --version >> /etc/rust-versions; \
    rustc +nightly --version >> /etc/rust-versions; \
    chmod -R a+rwX $RUSTUP_HOME $CARGO_HOME; \
    echo installed rust

RUN set -eux; \
    apt-get install -y cmake binutils-dev libelf-dev libdw-dev; \
    git clone https://github.com/jix/kcov; \
    cd kcov; \
    git checkout no-disable-aslr; \
    mkdir build; \
    cd build; \
    cmake ..; \
    make -j$(nproc); \
    make install; \
    cd ../..; \
    rm -rf kcov; \
    echo installed kcov

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
    cd ../..; \
    rm -r acl2-8.1 acl2-8.1.tar.gz; \
    echo installed check-lrat

RUN set -eux; \
    git clone https://github.com/marijnheule/drat-trim; \
    cd drat-trim; \
    make; \
    cp drat-trim /usr/local/bin/; \
    cd ..; \
    rm -rf drat-trim; \
    echo installed drat-trim

USER circleci
