ARG BASE_IMAGE=ghcr.io/thelastdeploy/linux-base:latest
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive
ARG TERRAFORM_VERSION=1.9.8

RUN wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/ \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && terraform version

STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
