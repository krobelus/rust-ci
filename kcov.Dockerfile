FROM circleci/buildpack-deps:stretch
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

