FROM gitpod/workspace-full

USER root

# Install required packages
RUN apt-get update && apt-get install -y \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    bridge-utils \
    vagrant \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add Gitpod user to required groups
RUN adduser gitpod libvirt
RUN adduser gitpod libvirt-qemu

USER gitpod

# Install Vagrant libvirt plugin
RUN vagrant plugin install vagrant-libvirt
