FROM ubuntu:20.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    snmp \
    snmpd \
    snmp-mibs-downloader \
    net-tools \
    iproute2 \
    wget \
    curl \
    nano \
    vim \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download MIBs
RUN download-mibs

# Create working directory
RUN mkdir -p /home/gp2/mibs

# Configure SNMP for agent role
RUN echo "rocommunity public" > /etc/snmp/snmpd.conf \
    && echo "agentAddress udp:161" >> /etc/snmp/snmpd.conf \
    && echo "trap2sink 10.0.123.2:162 public" >> /etc/snmp/snmpd.conf

# Set environment variables
ENV MIBS=ALL
ENV MIBDIRS=/usr/share/snmp/mibs:/home/gp2/mibs

# Expose SNMP agent port
EXPOSE 161/udp

# Start SNMP agent
CMD ["snmpd", "-f", "-Lo", "-d"]
