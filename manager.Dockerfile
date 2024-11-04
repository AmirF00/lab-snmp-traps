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

# Configure SNMP for manager role
RUN echo "rocommunity public" > /etc/snmp/snmpd.conf \
    && echo "agentAddress udp:162" >> /etc/snmp/snmpd.conf

# Configure trap receiver
COPY gp2/snmptrapd.p2.conf /etc/snmp/snmptrapd.conf

# Set environment variables
ENV MIBS=ALL
ENV MIBDIRS=/usr/share/snmp/mibs:/home/gp2/mibs

# Expose SNMP trap port
EXPOSE 162/udp

# Start trap receiver
CMD ["snmptrapd", "-f", "-Lo", "-d"]
