FROM hippware/alpine-erlang:21.2

LABEL maintainer="Paul Schoenfelder <paulschoenfelder@gmail.com>"

# Important!  Update this no-op ENV variable when this Dockerfile
# is updated with the current date. It will force refresh of all
# of the base images and things like `apt-get update` won't be using
# old cached versions when the Dockerfile is built.
ENV REFRESHED_AT=2019-02-15 \
    ELIXIR_VERSION=v1.7.4

WORKDIR /tmp/elixir-build

RUN \
    apk --no-cache --update upgrade && \
    apk add --no-cache --update --virtual .elixir-build \
      git make && \
    git clone https://github.com/elixir-lang/elixir --depth 1 --branch $ELIXIR_VERSION && \
    cd elixir && \
    export PREFIX=/usr && \
    make && make install && \
    mix local.hex --force && \
    mix local.rebar --force && \
    cd $HOME && \
    chown -R default .mix && \
    rm -rf /tmp/elixir-build && \
    apk del --no-cache .elixir-build

WORKDIR ${HOME}

CMD ["/bin/sh"]
