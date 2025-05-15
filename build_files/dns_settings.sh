# #!/usr/bin/env bash

set -euo pipefail

# --- DNSCrypt Configuration ---
log "Setting up AdGuard Family DNS over HTTPS"
mkdir -p /etc/dnscrypt-proxy
cat <<EOF > /etc/dnscrypt-proxy/dnscrypt-proxy.toml
server_names = ['adguard-family']

listen_addresses = ['127.0.2.1:53']

[static.'adguard-family']
stamp = 'sdns://AQMAAAAAAAAAETk0LjE0MC4xNC4xNTo1NDQzILgxXdexS27jIKRw3C7Wsao5jMnlhvhdRUXWuMm1AFq6ITIuZG5zY3J5cHQuZmFtaWx5Lm5zMS5hZGd1YXJkLmNvbQ'
EOF

mkdir -p /etc/systemd/resolved.conf.d
cat <<EOF > /etc/systemd/resolved.conf.d/selene-dns.conf
[Resolve]
DNS=127.0.2.1
DNSStubListener=no
EOF

mkdir -p /etc/systemd/system/multi-user.target.wants
ln -sf /usr/lib/systemd/system/dnscrypt-proxy.service /etc/systemd/system/multi-user.target.wants/dnscrypt-proxy.service
