FROM rustlang/rust:nightly as builder

RUN USER=root mkdir spoonfeed
WORKDIR ./spoonfeed

RUN cargo init
COPY ./spoonfeed-server/Cargo.toml ./Cargo.toml
RUN cargo +nightly build --release -Z sparse-registry

COPY ./spoonfeed-server .

RUN cargo +nightly build --release -Z sparse-registry

FROM frolvlad/alpine-glibc

EXPOSE 8080

# RUN groupadd appuser \
#     && useradd -g appuser appuser \

RUN mkdir -p /app \
    && mkdir -p /app/static

COPY spoonfeed-server/config /app/config
COPY --from=builder /spoonfeed/target/release/spoonfeed-server /app/spoonfeed

ENV RUST_LOG=info

# COPY ./docker-entrypoint.sh /app/docker-entrypoint.sh

WORKDIR /app
ENTRYPOINT ["./spoonfeed"]