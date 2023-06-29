FROM rustlang/rust:nightly as builder

RUN USER=root mkdir spoonfeed
WORKDIR ./spoonfeed

ADD ./ ./

RUN cargo +nightly build --release -Z sparse-registry

FROM frolvlad/alpine-glibc
ARG APP=/usr/src/app

EXPOSE 8080

# RUN groupadd appuser \
#     && useradd -g appuser appuser \

RUN mkdir -p ${APP} \
    && mkdir -p ${APP}/static

COPY --from=builder /spoonfeed/target/release/spoonfeed-server ${APP}/spoonfeed

# RUN chown -R appuser:appuser ${APP}

# USER appuser
WORKDIR ${APP}

ENTRYPOINT ["./spoonfeed"]
# CMD ["./spoonfeed"]