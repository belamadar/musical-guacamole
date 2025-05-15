#!/usr/bin/env bash
set -euo pipefail

trap '[[ $BASH_COMMAND != echo* ]] && [[ $BASH_COMMAND != log* ]] && echo "+ $BASH_COMMAND"' DEBUG

log() {
  echo "=== $* ==="
}

log "Starting Selene OS package setup"

# --- RPM REPOS ---

run0 curl -fsSLo /etc/yum.repos.d/brave-browser.repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo


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

  ["brave-browser"]="brave-browser"
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
sudo mkdir -p /etc/opt/brave/policies/managed
cat <<EOF > /etc/opt/brave/policies/managed/settings.json
{
  "DefaultSearchProviderEnabled": true,
  "DefaultSearchProviderName": "DuckDuckGo",
  "DefaultSearchProviderSearchURL": "https://duckduckgo.com/?q={searchTerms}",
  "DefaultSearchProviderSuggestURL": "https://duckduckgo.com/ac/?q={searchTerms}&type=list",
  "DefaultSearchProviderIconURL": "https://duckduckgo.com/favicon.ico",
  "DefaultSearchProviderKeyword": "duckduckgo",

  "ExtensionInstallForcelist": [
    "bkdgflcldnnnapblkhphbgpggdiikppg",  // DuckDuckGo Privacy Essentials
    "ghbmnnjooekpmoecnnnilnnbdlolhkhi",  // ClearURLs
    "dcpihecpambacapedldabdbpakmachpb"   // Scratch Addons
  ]

}
EOF

log "Selene OS package setup complete"
