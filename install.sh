#!/bin/bash
set -e

echo "Instaling necessary packages..."
sudo pacman -S --needed --noconfirm - <pacman.txt

if ! command -v paru &>/dev/null; then
  echo "Paru not found. Installing..."
  TEMP_DIR=$(mktemp -d)
  git clone https://aur.archlinux.org/paru.git "$TEMP_DIR"
  cd "$TEMP_DIR"
  makepkg -si --noconfirm
  cd -
  rm -rf "$TEMP_DIR"
fi

echo "Instaling packages from the AUR..."
paru -S --needed --noconfirm noctalia-greeter redhat-fonts

echo "Instaling packages from flathub..."
flatpak install -y --noninteractive flathub app.zen_browser.zen

echo "Installing display manager..."
sudo install -Dm 644 ./greetd/config.toml /etc/greetd/config.toml
sudo systemctl enable greetd.service

echo "Copying user configs to ~/.config..."
mkdir -p ~/.config
rsync -a ./config/ ~/.config/

echo "Installing ghostty shader"
mkdir -p ~/.config/ghostty/shaders
git clone --depth 1 https://github.com/hackr-sh/ghostty-shaders /tmp/ghostty-shaders
cp /tmp/ghostty-shaders/bloom.glsl ~/.config/ghostty/shaders/
rm -rf /tmp/ghostty-shaders

echo "Copying Arch Linux wallpapers..."
mkdir -p ~/Pictures/Wallpapers
cp /usr/share/backgrounds/archlinux/{landscape,lone,mountain,reflected,snow,svalbard}.jpg ~/Pictures/Wallpapers/

echo "Configuring environment variables..."
cat <<EOF | sudo tee -a /etc/environment
EDITOR=nvim
VISUAL=nvim
QT_QPA_PLATFORMTHEME=gtk3
EOF

echo "Finished. Ready to reboot"
read -p "Reboot now? [Y/n]: " reboot_prompt
if [[ "$reboot_prompt" =~ ^([yY][eE][sS]|[yY]|"")$ ]]; then
  echo "Rebooting in 3 seconds..."
  sleep 3
  sudo reboot
else
  echo "Reboot canceled"
fi
