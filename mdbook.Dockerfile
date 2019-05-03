# dep rust-stable
# dep build-mdbook
FROM jixone/rust-ci:rust-stable
COPY --from=jixone/rust-ci:build-mdbook /usr/local/cargo/bin/mdbook /usr/local/cargo/bin/mdbook
