#!/bin/bash

set -e

echo "🧹 Uninstalling dotfiles..."

# --------------------------------------------------
# Safety check
# --------------------------------------------------
if [ "$EUID" -eq 0 ]; then
  echo "❌ Do not run this script as root"
  exit 1
fi

# --------------------------------------------------
# Remove configs
# --------------------------------------------------
echo "🗑️  Removing configs..."
for dir in hypr kitty rofi swaync waybar; do
  if [ -d "$HOME/.config/$dir" ]; then
    rm -rf "$HOME/.config/$dir"
    echo "  • Removed $dir"
  fi
done

# --------------------------------------------------
# Remove walset
# --------------------------------------------------
if [ -f "$HOME/.local/bin/walset" ]; then
  rm "$HOME/.local/bin/walset"
  echo "🎨 Removed walset"
fi

# --------------------------------------------------
# Remove wallpapers (ONLY yours)
# --------------------------------------------------
if [ -d "$HOME/Pictures/Wallpapers" ]; then
  echo "🖼️  Removing wallpapers folder..."
  rm -rf "$HOME/Pictures/Wallpapers"
fi

# --------------------------------------------------
# Remove walset config (if exists)
# --------------------------------------------------
if [ -d "$HOME/.config/walset" ]; then
  rm -rf "$HOME/.config/walset"
fi

# --------------------------------------------------
# Restore PATH line safely (optional cleanup)
# --------------------------------------------------
if [ -f "$HOME/.zshrc" ]; then
  sed -i '/\.local\/bin/d' "$HOME/.zshrc"
fi

# --------------------------------------------------
# Done
# --------------------------------------------------
echo ""
echo "✅ Uninstall complete!"
echo "ℹ️  Old configs are NOT restored automatically."
echo "ℹ️  You can manually restore from ~/.config-backup-* if needed."
