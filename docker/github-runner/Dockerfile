FROM ubuntu:24.04 AS builder

USER root

ARG RUNNER_VERSION="2.323.0" \
    S6_OVERLAY_VERSION="3.2.0.2"

ENV DEBIAN_FRONTEND=noninteractive \
    XDG_RUNTIME_DIR=/run/user/1000 \
    DOCKER_HOST=unix:///run/user/1000/docker.sock \
    ACTIONS_RUNNER_PRINT_LOG_TO_STDOUT=1

RUN apt update && \
    apt upgrade -y && \
    apt install -y bash build-essential ca-certificates curl dbus-user-session fuse-overlayfs git iproute2 jq kmod \
                   libffi-dev libicu-dev libkrb5-3 liblttng-ust1t64 libssl-dev python3 python3-dev python3-pip python3-venv \
                   s6 tar uidmap unzip wget xz-utils zip zlib1g

RUN curl -sfL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh && \
    rm -f get-docker.sh && \
    update-alternatives --set iptables /usr/sbin/iptables-legacy && \
    update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy && \
    mkdir -p $XDG_RUNTIME_DIR && \
    chown -R ubuntu:ubuntu $XDG_RUNTIME_DIR

RUN apt clean -y && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz && \
    rm /tmp/s6-overlay-noarch.tar.xz && \
    rm /tmp/s6-overlay-x86_64.tar.xz && \
    rm /tmp/s6-overlay-symlinks-noarch.tar.xz && \
    rm /tmp/s6-overlay-symlinks-arch.tar.xz

COPY services.d /etc/services.d
RUN chown -R ubuntu:ubuntu /etc/services.d

COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

COPY stop.sh /usr/local/bin/stop.sh
RUN chmod +x /usr/local/bin/stop.sh

USER ubuntu
WORKDIR /work/actions-runner

RUN curl -sfL https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -o runner.tar.gz && \
    tar -xvf runner.tar.gz && \
    rm -f runner.tar.gz

WORKDIR /work
ENTRYPOINT ["s6-svscan", "/etc/services.d"]
