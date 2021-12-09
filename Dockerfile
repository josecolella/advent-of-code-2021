FROM ruby:3.0.3-slim-bullseye

WORKDIR /opt

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y dumb-init

COPY . /opt

ENTRYPOINT [ "dumb-init" ]