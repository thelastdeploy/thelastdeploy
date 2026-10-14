ARG BASE_IMAGE=ghcr.io/thelastdeploy/linux-base:latest
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    nginx apache2-utils \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && systemctl enable nginx || true

STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
