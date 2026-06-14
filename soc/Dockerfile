FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    iproute2 \
    iputils-ping \
    curl \
    wget \
    nano \
    jq \
    tcpdump \
    net-tools \
    rsyslog \
    python3 \
    python3-pip \
    less \
    procps \
    ca-certificates \
    gnupg \
    lsb-release \
    && wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/9.x/apt stable main" > /etc/apt/sources.list.d/elastic-9.x.list \
    && apt-get update \
    && apt-get install -y elasticsearch kibana filebeat \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash", "-c", "tail -f /dev/null"]

EXPOSE 5601 9200