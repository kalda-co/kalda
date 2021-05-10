# The version of Alpine to use for the final image
# This should match the version of Alpine that the release-builder image uses
# https://github.com/bitwalker/alpine-erlang/blob/master/VERSION
ARG ALPINE_VERSION=3.13.2

# 1.11.0
FROM bitwalker/alpine-elixir-phoenix:1.11.3 as release-builder

ENV \
  MIX_ENV=prod \
  HOME=/app/
WORKDIR $HOME

RUN apk add --update alpine-sdk coreutils

# Download and compile Hex deps
COPY mix.exs mix.lock ./
COPY config ./config
RUN mix do \
  deps.get --only prod, \
  deps.compile

# Download npm deps
COPY package.json package-lock.json ./ 
RUN npm ci

# Compile backend app
COPY lib ./lib
COPY priv ./priv
RUN mix compile

# Compile frontend app
COPY . .
RUN npm run deploy && mix phx.digest

# Compile the release
RUN mix release

#
# Final image
#
FROM alpine:${ALPINE_VERSION}
LABEL maintainer="Kalda <dev@kalda.co>"

EXPOSE 4000
ENV PORT=4000 \
  MIX_ENV=prod \
  SHELL=/bin/bash \
  LANG=en_US.UTF-8 \
  HOME=/app/ \
  TERM=xterm 
WORKDIR $HOME

# Copy the compiled release to this image
COPY --from=release-builder /app/_build/prod/rel/kalda ./

# Install OS deps and create unprivileged user to run app as
RUN apk add --no-cache openssl-dev bash libgcc curl \
  && adduser -S www-kalda \
  && chown --recursive www-kalda $HOME
USER www-kalda

# Run the app as the container starts
CMD ["/app/bin/kalda", "start"]
