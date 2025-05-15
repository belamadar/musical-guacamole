#!/bin/bash

set -ouex pipefail

### Uninstall packages from the base image

rpm-ostree override remove \
	plasma-discover \
	plasma-discover-flatpak \
	plasma-discover-notifier \
	firefox || true

### Install packages

# Install packages for educational/tinkering tools
dnf5 install -y \
  python3 \
  java-21-openjdk \
  gedit \
  neovim \
  gnome-disk-utility \
  transmission-gtk \
  simple-scan

# Install CLI tools
dnf5 install -y \
  htop \
  fastfetch \
  dnscrypt-proxy \
  podman

# Install useful flatpaks
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y --system com.brave.Browser

### Setup adblocking and family protection

# Configure AdGuard Family DoH
mkdir -p /etc/dnscrypt-proxy
cat <<EOF > /etc/dnscrypt-proxy/dnscrypt-proxy.toml
server_names = ['adguard-family']

listen_addresses = ['127.0.2.1:53']

[static.'adguard-family']
stamp = 'sdns://AQMAAAAAAAAAETk0LjE0MC4xNC4xNTo1NDQzILgxXdexS27jIKRw3C7Wsao5jMnlhvhdRUXWuMm1AFq6ITIuZG5zY3J5cHQuZmFtaWx5Lm5zMS5hZGd1YXJkLmNvbQ'
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

### Adjust system settings

xdg-settings set default-web-browser com.brave.Browser.desktop || true

