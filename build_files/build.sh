#!/bin/bash

set -ouex pipefail

### Install packages

# Install packages for educational/tinkering tools
dnf5 install -y /
  python3 \
  java-17-openjdk \
  gedit \
  neovim \
  gnome-disk-utility \
  transmission-gtk \
  simple-scan

# Install CLI tools
dnf5 install -y /
  htop /
  fastfetch /
  dnscrypt-proxy /
  podman

### Setup adblocking and family protection

# Configure AdGuard Family DoH
mkdir -p /etc/dnscrypt-proxy
cat <<EOF > /etc/dnscrypt-proxy/dnscrypt-proxy.toml
server_names = ['adguard-family']

listen_addresses = ['127.0.2.1:53']

[static.'adguard-family']
stamp = 'sdns://AgcAAAAAAAAAAAAPZG5zLmFkZ3VhcmQuY29tILkIXf-fksVr3I-ZgR9qp8rT4aAakm4PbXbVXq2s0UNR3zBkcMi5kbnMuYWRndWFyZC5jb20'
EOF

# Override systemd-resolved to use dnscrypt-proxy
mkdir -p /etc/systemd/resolved.conf.d
cat <<EOF > /etc/systemd/resolved.conf.d/selene-dns.conf
[Resolve]
DNS=127.0.2.1
DNSStubListener=no
EOF

# Enable dnscrypt-proxy on boot
mkdir -p /etc/systemd/system/multi-user.target.wants
ln -s /usr/lib/systemd/system/dnscrypt-proxy.service /etc/systemd/system/multi-user.target.wants/dnscrypt-proxy.service

#### Example for enabling a System Unit File

systemctl enable podman.socket
