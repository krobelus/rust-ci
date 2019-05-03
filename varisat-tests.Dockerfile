# dep kcov
# dep check-lrat
# dep drat-trim
FROM circleci/buildpack-deps:stretch
USER root

RUN apt-get install -y libdw1

COPY --from=jixone/rust-ci:kcov \
    /install/ \
    /

COPY --from=jixone/rust-ci:check-lrat \
    /usr/local/bin/sbcl \
    /usr/local/bin/check-lrat \
    /usr/local/bin/check-lrat.core \
    /usr/local/bin/check-clrat \
    /usr/local/bin/check-clrat.core \
    /usr/local/bin/

COPY --from=jixone/rust-ci:drat-trim /usr/local/bin/drat-trim /usr/local/bin/

USER circleci
