# Build Elixir release

FROM node:10.13 AS node-builder

WORKDIR /app
ADD . .

RUN bash download_web_client.sh

FROM hexpm/elixir:1.12.2-erlang-24.0-alpine-3.13.3 as builder

RUN apk --no-cache --update add bash build-base curl alpine-sdk coreutils python3 && \
  rm -rf /var/cache/apk/*

RUN mix local.hex --force && \
  mix local.rebar --force && \
  mix hex.info

WORKDIR /app
ENV MIX_ENV prod

COPY --from=node-builder /app/ .

RUN mix deps.get
RUN mix phx.digest
RUN mix release

# Definitive image

FROM library/alpine:3.13.3

RUN apk --update --no-cache add bash openssl curl alpine-sdk coreutils && \
  rm -rf /var/cache/apk/*

WORKDIR /app
COPY --from=builder /app/_build/prod/rel/bitwardex .

CMD ["./bin/bitwardex", "start"]
