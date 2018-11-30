# Build Elixir release

FROM library/elixir:1.7.3-alpine as builder

RUN apk --no-cache --update add bash build-base curl alpine-sdk coreutils nodejs nodejs-npm && \
  rm -rf /var/cache/apk/*

RUN mix local.hex --force && \
  mix local.rebar --force && \
  mix hex.info

WORKDIR /app
ENV MIX_ENV prod
ADD . .

RUN mix deps.get

RUN cd /app/apps/bitwardex_web/ && \
  bash download_web_client.sh && \
  cd /app

RUN mix release --env=$MIX_ENV

# Definitive image

FROM library/alpine:3.7

RUN apk --update --no-cache add bash openssl curl alpine-sdk coreutils && \
  rm -rf /var/cache/apk/*

WORKDIR /app
COPY --from=builder /app/_build/prod/rel/bitwardex .

CMD ["./bin/bitwardex", "foreground"]
