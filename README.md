# Selene OS

Selene OS is a custom Fedora Budgie Atomic spin designed for kids, young tinkerers, and privacy-conscious users. It features a friendly interface, strong parental controls, and a playful, engaging design — all built on the Universal Blue Budgie base.

## 🌟 Goals
- Safe, fun, and user-friendly
- Encourage tinkering and creativity
- Maintain system integrity with atomic updates
- Built-in privacy and ad-blocking

## 🧩 Core Setup
- [ ] Set hostname to `selene`
- [ ] Enable automatic updates (rpm-ostree + flatpak)
- [ ] Create a welcome/setup script for first boot
- [x] Rebase to Universal Blue base (`budgie-atomic-main`)
- [ ] Configure rollback and backup guidance

## 🎨 Appearance
- [ ] Custom wallpaper and boot splash (light/dark celestial theme)
- [x] Kid-friendly Budgie panel layout (large icons, simple labels)
- [ ] Papirus or Qogir icon theme
- [ ] Custom cursor theme

## 🧠 System Settings
- [ ] Use AdGuard or NextDNS with family filter
- [ ] Set up Flatseal with preconfigured permission limits
- [ ] Enable Night Light and system-wide dark mode
- [ ] Add parental control rules (e.g., restricted user accounts)

## 🧰 Essential Software

### Productivity & Learning
- GNOME Text Editor or Mousepad
- Calculator
- GCompris (educational games)
- LibreOffice (optional)
- **Brave Browser** with preinstalled extensions

### Creative Tools
- Krita (drawing)
- Tux Paint (kids drawing)
- Inkscape or Pinta (vector/raster art)

### Coding
- Scratch
- Thonny (Python IDE)
- VS Code OSS

## 🔐 Security & Privacy
- [ ] UFW enabled
- [ ] Minimal sudo / polkit tweaks for guardian control
- [ ] Brave with:
  - DuckDuckGo Privacy Essentials
  - ClearURLs
  - Scratch Addons
- [ ] Disable telemetry
- [ ] Tailscale for remote assistance

## 📦 Flatpak Configuration
- [x] Use Flathub by default
- [ ] Weekly auto-update Flatpaks
- [ ] Prevent non-admin app installs

## 🧪 Nerdy Extras (Optional)
- Waydroid (Android in container)
- Bottles (Wine sandboxing)
- Podman setup for container tinkering
- Neofetch/Fastfetch with custom Selene ASCII art

## 🛠️ Custom Scripts / GUI Tools
- "Fix my system" config reset tool
- "Learn to Tinker" launcher
- GUI updater/reset panel
- "Ask for Help" (Tailscale ping / Discord bot integration)
