ARG BASE_IMAGE=ghcr.io/thelastdeploy/tld-ubuntu:latest
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive
ARG K3S_VERSION=v1.30.0+k3s1

RUN curl -sLO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm -f kubectl \
    && curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash \
    && curl -fsSL -o /usr/local/bin/k3s "https://github.com/k3s-io/k3s/releases/download/${K3S_VERSION}/k3s" \
    && chmod +x /usr/local/bin/k3s

COPY k3s.service /etc/systemd/system/k3s.service
COPY tld-k8s-setup.sh /usr/local/bin/tld-k8s-setup.sh
COPY tld-k8s-setup.service /etc/systemd/system/tld-k8s-setup.service

RUN chmod +x /usr/local/bin/tld-k8s-setup.sh \
    && systemctl enable k3s.service tld-k8s-setup.service

STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
