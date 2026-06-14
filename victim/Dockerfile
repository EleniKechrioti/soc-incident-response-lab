FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    iptables \
    iproute2 \
    ulogd2 \
    iputils-ping \
    curl \
    wget \
    nano \
    nginx \
    openssh-server \
    rsyslog \
    net-tools \
    tcpdump \
    suricata \
    jq \
    && mkdir -p /var/run/sshd \
    && echo 'root:toor' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/^module(load="imklog")/#module(load="imklog")/' /etc/rsyslog.conf \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN suricata-update
COPY config/suricata.yaml /etc/suricata/suricata.yaml
COPY rules/local.rules /var/lib/suricata/rules/local.rules
EXPOSE 80 22