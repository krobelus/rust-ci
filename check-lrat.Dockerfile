FROM circleci/buildpack-deps:stretch
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

