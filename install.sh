#!/bin/bash

set -e

echo "🚀 Installing dotfiles..."

# --------------------------------------------------
# Safety check
# --------------------------------------------------
if [ "$EUID" -eq 0 ]; then
  echo "❌ Do not run this script as root"
  exit 1
fi

DOTS_DIR="$(pwd)"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d%H%M%S)"

# --------------------------------------------------
# Create directories
# --------------------------------------------------
echo "📁 Creating directories..."
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/Pictures/Wallpapers"

# --------------------------------------------------
# Backup existing configs
# --------------------------------------------------
echo "🛟 Backing up existing configs..."
mkdir -p "$BACKUP_DIR"

for dir in hypr kitty rofi swaync waybar; do
  if [ -d "$HOME/.config/$dir" ]; then
    mv "$HOME/.config/$dir" "$BACKUP_DIR/"
    echo "  • Backed up $dir"
  fi
done

# --------------------------------------------------
# Install configs
# --------------------------------------------------
echo "📂 Installing configs..."
cp -r conf/* "$HOME/.config/"

# --------------------------------------------------
# Install walset script
# --------------------------------------------------
echo "🎨 Installing walset..."
cp local/bin/walset "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin/walset"

# --------------------------------------------------
# Ensure Waybar script executable
# --------------------------------------------------
if [ -f "$HOME/.config/waybar/scripts/launch.sh" ]; then
  chmod +x "$HOME/.config/waybar/scripts/launch.sh"
fi

# --------------------------------------------------
# Install wallpapers
# --------------------------------------------------
echo "🖼️  Installing wallpapers..."
cp -r wallpapers/* "$HOME/Pictures/Wallpapers/"

# --------------------------------------------------
# Set default wallpaper
# --------------------------------------------------
DEFAULT_WALL="$HOME/Pictures/Wallpapers/pastel-window.png"

if [ -x "$HOME/.local/bin/walset" ] && [ -f "$DEFAULT_WALL" ]; then
  echo "🌿 Setting default wallpaper (pastel-window.png)"
  walset "$DEFAULT_WALL" || walset
fi

# --------------------------------------------------
# Install .zshrc
# --------------------------------------------------
echo "🐚 Installing .zshrc..."
cp home/.zshrc "$HOME/"

# --------------------------------------------------
# Ensure ~/.local/bin in PATH
# --------------------------------------------------
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
fi

# --------------------------------------------------
# Done
# --------------------------------------------------
echo ""
echo "✅ Installation complete!"
echo "🗂️  Backup stored at:"
echo "   $BACKUP_DIR"
echo ""
echo "➡️  Log out and log back in (or reboot) to apply everything."
