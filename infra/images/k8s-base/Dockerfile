ARG BASE_IMAGE=ghcr.io/thelastdeploy/linux-base:latest
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive
ARG KIND_VERSION=v0.24.0

RUN curl -sLO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm -f kubectl \
    && curl -sLo /usr/local/bin/kind "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64" \
    && chmod +x /usr/local/bin/kind \
    && curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
