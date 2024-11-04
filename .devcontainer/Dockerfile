FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install required packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        snmp \
        snmpd \
        snmp-mibs-downloader \
        net-tools \
        iproute2 \
        wget \
        curl \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p /workspaces/lab-snmp-traps/gp2/mibs

# Copy SNMP configurations
COPY snmpd.conf /etc/snmp/
COPY snmptrapd.conf /etc/snmp/

WORKDIR /workspaces/lab-snmp-traps
