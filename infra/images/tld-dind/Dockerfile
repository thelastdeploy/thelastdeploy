ARG BASE_IMAGE=ghcr.io/thelastdeploy/tld-ubuntu:latest
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    apt-transport-https ca-certificates gnupg lsb-release iptables \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
    && apt-get update -qq && apt-get install -y --no-install-recommends \
    docker-ce docker-ce-cli containerd.io docker-compose-plugin \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && systemctl enable docker || true

VOLUME ["/var/lib/docker", "/var/lib/containerd"]

STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
