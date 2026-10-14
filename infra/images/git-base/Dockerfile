ARG BASE_IMAGE=ghcr.io/thelastdeploy/linux-base:latest
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    git git-lfs \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && git config --system user.name "TheLastDeploy Student" \
    && git config --system user.email "student@thelastdeploy.com" \
    && git config --system init.defaultBranch main

STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
