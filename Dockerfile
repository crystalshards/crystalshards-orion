FROM 84codes/crystal:1.8.1-alpine as builder

# Setup
WORKDIR /build
RUN apk add --no-cache openssl ca-certificates yaml-static curl cmake musl clang clang-dev alpine-sdk dpkg
RUN openssl version -d

# Deps
COPY shard.lock shard.yml ./
RUN shards install --production

# Build
COPY . .
RUN shards build --release --production --static

# Import to scratch image
FROM scratch

ARG TARGET
COPY --from=builder /build/bin/* /
COPY --from=builder /build/bin/$TARGET /.main
COPY --from=builder /etc/ssl/cert.pem /etc/ssl1.1/
