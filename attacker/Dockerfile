FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    iproute2 \
    nmap \
    hydra \
    nikto \
    iputils-ping \
    net-tools \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash", "-c", "tail -f /dev/null"]