#!/usr/bin/env bash
set -euo pipefail

trap '[[ $BASH_COMMAND != echo* ]] && [[ $BASH_COMMAND != log* ]] && echo "+ $BASH_COMMAND"' DEBUG

log() {
  echo "=== $* ==="
}

log "Starting Selene OS package setup"

# --- RPM PACKAGES ---

declare -A RPM_PACKAGES=(
  ["fedora"]="\
    plymouth \
    plymouth-plugin-script \
    python3 \
    java-21-openjdk \
    gedit \
    neovim \
    gnome-disk-utility \
    transmission-gtk \
    simple-scan \
    htop \
    fastfetch \
    dnscrypt-proxy \
    podman \
    git \
  "
)

log "Installing RPM packages"
for repo in "${!RPM_PACKAGES[@]}"; do
  read -ra pkg_array <<< "${RPM_PACKAGES[$repo]}"
  cmd=(rpm-ostree install)
  cmd+=("${pkg_array[@]}")
  "${cmd[@]}"
done

# --- FLATPAK INSTALLATION ---

log "Installing Flatpaks"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

if [[ -f /ctx/flatpaks ]]; then
  while IFS= read -r app_id; do
    flatpak install -y --system "$app_id"
  done < /ctx/flatpaks
else
  log "No flatpaks file found, skipping Flatpak installation"
fi


# --- CHANGE SETTINGS ---

xdg-settings set default-web-browser com.brave.Browser.desktop || true
flatpak override --system --filesystem=xdg-download --filesystem=home com.brave.Browser

log "Adding Brave first-login config for DuckDuckGo"
mkdir -p /etc/skel/.config/autostart
cat <<EOF > /etc/skel/.config/autostart/selene-brave-duckduckgo.desktop
[Desktop Entry]
Name=Set Brave Search Engine
Exec=/usr/bin/env bash -c 'sleep 5 && mkdir -p ~/.config/BraveSoftware/Brave-Browser/Default && cat <<EOT > ~/.config/BraveSoftware/Brave-Browser/Default/Preferences
{
  "default_search_provider": {
    "enabled": true,
    "name": "DuckDuckGo",
    "keyword": "duckduckgo.com",
    "search_url": "https://duckduckgo.com/?q={searchTerms}",
    "suggest_url": "https://ac.duckduckgo.com/ac/?q={searchTerms}&type=list"
  }
}
EOT'
Type=Application
X-GNOME-Autostart-enabled=true
EOF

log "Selene OS package setup complete"
