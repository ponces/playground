FROM ubuntu:24.04 AS base

USER root

ARG RUNNER_VERSION="2.323.0" \
    S6_OVERLAY_VERSION="3.2.0.2"

ENV DEBIAN_FRONTEND=noninteractive \
    ACTIONS_RUNNER_PRINT_LOG_TO_STDOUT=1

RUN apt update && \
    apt upgrade -y && \
    apt install -y aapt android-sdk-libsparse-utils bash bc bison build-essential ca-certificates curl \
                   dos2unix flex fontconfig fuse-overlayfs g++-multilib gcc-multilib git gnupg gperf \
                   imagemagick iproute2 jq kmod lib32z1-dev libc6-dev-i386 libelf-dev libffi-dev \
                   libgl1-mesa-dev libicu-dev libkrb5-3 liblttng-ust1t64 libncurses-dev libssl-dev \
                   libstdc++6 libx11-dev libxml2-utils locales lunzip lzip lzop m4 make nano \
                   python-is-python3 python3 python3-dev python3-pip python3-venv rsync squashfs-tools \
                   s6 tar unzip wget x11proto-core-dev xattr xmlstarlet xsltproc xz-utils zip zlib1g \
                   zlib1g-dev && \
    apt install -y --no-install-recommends openjdk-17-jdk && \
    apt clean -y && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales

RUN curl -sfL https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo && \
    chmod +x /usr/local/bin/repo

RUN curl -sfL https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt install -y git-lfs

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

FROM base AS dind-runner

ENV XDG_RUNTIME_DIR=/run/user/1000 \
    DOCKER_HOST=unix:///run/user/1000/docker.sock

RUN apt update && \
    apt install -y dbus-user-session iptables uidmap

RUN curl -sfSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh && \
    rm -f get-docker.sh && \
    update-alternatives --set iptables /usr/sbin/iptables-legacy && \
    update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy && \
    mkdir -p $XDG_RUNTIME_DIR && \
    chown -R ubuntu:ubuntu $XDG_RUNTIME_DIR

RUN apt clean -y && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*

USER ubuntu
WORKDIR /work/actions-runner

RUN curl -sfSL https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -o runner.tar.gz && \
    tar -xvf runner.tar.gz && \
    rm -f runner.tar.gz

WORKDIR /work
ENTRYPOINT ["s6-svscan", "/etc/services.d"]

FROM base AS dood-runner

RUN curl -sfSL https://download.docker.com/linux/static/stable/x86_64/docker-$(curl -sfSL https://get.docker.com/rootless | grep "STABLE_LATEST=" | cut -d'"' -f2).tgz -o docker.tgz && \
    tar -xvf docker.tgz && \
    cp -f docker/docker /usr/local/bin/docker && \
    rm -rf docker docker.tgz && \
    rm -rf /etc/services.d/docker && \
    sed -i '/docker/d' /etc/services.d/runner/run && \
    groupadd -g 999 docker && \
    usermod -aG docker ubuntu

USER ubuntu
WORKDIR /work/actions-runner

RUN curl -sfSL https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -o runner.tar.gz && \
    tar -xvf runner.tar.gz && \
    rm -f runner.tar.gz

WORKDIR /work
ENTRYPOINT ["s6-svscan", "/etc/services.d"]
