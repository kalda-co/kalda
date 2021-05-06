# The version of Alpine to use for the final image
# This should match the version of Alpine that the release-builder image uses
# https://github.com/bitwalker/alpine-erlang/blob/master/VERSION
arg ALPINE_VERSION=3.13.2

# 1.11.0
from bitwalker/alpine-elixir-phoenix@sha256:f55cb80820df7fb08c5c78071cf014abe39b31c702f5c004d6a6865060772b11 as release-builder

env \
  MIX_ENV=prod \
  HOME=/app/
workdir $HOME

run apk add --update alpine-sdk coreutils

# Download and compile Hex deps
copy mix.exs mix.lock ./
copy config ./config
run mix do \
  deps.get --only prod, \
  deps.compile

# Download npm deps
copy package.json package-lock.json ./ 
run npm ci

# Compile backend app
copy lib ./lib
copy priv ./priv
run mix compile

# Compile frontend app
copy . .
run npm run deploy && mix phx.digest

# Compile the release
run mix release

#
# Final image
#
from alpine:${ALPINE_VERSION}
label maintainer="Kalda <dev@kalda.co>"

expose 4000
env PORT=4000 \
  MIX_ENV=prod \
  SHELL=/bin/bash \
  LANG=en_US.UTF-8 \
  HOME=/app/ \
  TERM=xterm 
workdir $HOME

# Copy the compiled release to this image
copy --from=release-builder /app/_build/prod/rel/kalda ./

# Install OS deps and create unprivileged user to run app as
RUN apk add --no-cache openssl-dev bash libgcc \
  && adduser -S www-kalda \
  && chown --recursive www-kalda $HOME
USER www-kalda

# Run the app as the container starts
entrypoint ["/app/bin/kalda"]
cmd ["start"]
