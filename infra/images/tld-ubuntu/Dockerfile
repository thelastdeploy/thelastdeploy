FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive container=docker

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    bash coreutils sudo curl wget tar gzip rsync \
    net-tools iproute2 iputils-ping dnsutils \
    procps htop lsof sysstat strace \
    man-db vim nano less \
    openssh-client openssl ca-certificates \
    python3 python3-pip \
    jq unzip \
    cron logrotate rsyslog \
    systemd systemd-sysv dbus \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && systemctl mask \
        getty@tty1.service getty-static.service \
        systemd-remount-fs.service dev-hugepages.mount \
        sys-fs-fuse-connections.mount tmp.mount \
        systemd-update-utmp.service

STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
