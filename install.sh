#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

log() {
  printf "\n\033[1;32m==> %s\033[0m\n" "$*"
}

warn() {
  printf "\n\033[1;33m[WARN] %s\033[0m\n" "$*"
}

err() {
  printf "\n\033[1;31m[ERROR] %s\033[0m\n" "$*" >&2
}

require_apt() {
  if ! command -v apt >/dev/null 2>&1; then
    err "Script này chỉ hỗ trợ Ubuntu/Debian-based distro có apt."
    exit 1
  fi
}

apt_install() {
  log "Installing APT packages..."

  sudo apt update

  sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    wget \
    gnupg \
    lsb-release \
    software-properties-common \
    git \
    stow \
    build-essential \
    unzip \
    jq \
    xorg \
    xserver-xorg \
    xserver-xorg-input-libinput \
    x11-xserver-utils \
    xinput \
    dbus-x11 \
    xdg-utils \
    dex \
    i3 \
    i3status \
    i3lock \
    rofi \
    dunst \
    libnotify-bin \
    pulseaudio-utils \
    pavucontrol \
    playerctl \
    brightnessctl \
    alacritty \
    feh \
    flameshot \
    xclip \
    xsel \
    network-manager-gnome \
    blueman \
    fonts-font-awesome \
    fonts-jetbrains-mono \
    zsh \
    fzf \
    command-not-found

}

install_brave() {
  log "Installing Brave Browser..."

  if command -v brave-browser >/dev/null 2>&1; then
    log "Brave already installed."
    return
  fi

  sudo install -d -m 0755 /etc/apt/keyrings

  curl -fsSLo /tmp/brave-browser-archive-keyring.gpg \
    https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

  sudo install -m 0644 /tmp/brave-browser-archive-keyring.gpg \
    /etc/apt/keyrings/brave-browser-archive-keyring.gpg

  echo "deb [signed-by=/etc/apt/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" \
    | sudo tee /etc/apt/sources.list.d/brave-browser-release.list >/dev/null

  sudo apt update
  sudo apt install -y brave-browser
}

install_vscode() {
  log "Installing Visual Studio Code..."

  if command -v code >/dev/null 2>&1; then
    log "VSCode already installed."
    return
  fi

  sudo install -d -m 0755 /etc/apt/keyrings

  wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor \
    | sudo tee /etc/apt/keyrings/packages.microsoft.gpg >/dev/null

  sudo chmod 0644 /etc/apt/keyrings/packages.microsoft.gpg

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
    | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null

  sudo apt update
  sudo apt install -y code
}

clone_or_update() {
  local repo="$1"
  local dest="$2"

  if [ -d "$dest/.git" ]; then
    log "Updating $(basename "$dest")..."
    git -C "$dest" pull --ff-only || warn "Không update được $dest, bỏ qua."
  else
    log "Cloning $(basename "$dest")..."
    git clone --depth=1 "$repo" "$dest"
  fi
}

install_oh_my_zsh() {
  log "Installing Oh My Zsh and plugins..."

  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
  else
    log "Oh My Zsh already exists."
  fi

  local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  mkdir -p "$zsh_custom/plugins"

  clone_or_update \
    https://github.com/zsh-users/zsh-autosuggestions.git \
    "$zsh_custom/plugins/zsh-autosuggestions"

  clone_or_update \
    https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$zsh_custom/plugins/zsh-syntax-highlighting"

  clone_or_update \
    https://github.com/zsh-users/zsh-completions.git \
    "$zsh_custom/plugins/zsh-completions"

  clone_or_update \
    https://github.com/Aloxaf/fzf-tab.git \
    "$zsh_custom/plugins/fzf-tab"
}

stow_module() {
  local module="$1"

  if [ -d "$DOTFILES_DIR/$module" ]; then
    log "Stowing $module..."
    stow --dir="$DOTFILES_DIR" --target="$HOME" --restow "$module"
  else
    warn "Bỏ qua $module vì không có folder: $DOTFILES_DIR/$module"
  fi
}

apply_dotfiles() {
  log "Applying dotfiles with GNU Stow..."

  if [ ! -d "$DOTFILES_DIR" ]; then
    err "Không tìm thấy DOTFILES_DIR: $DOTFILES_DIR"
    exit 1
  fi

  cd "$DOTFILES_DIR"

  stow_module i3
  stow_module rofi
  stow_module dunst
  stow_module zsh
  stow_module scripts
  stow_module alacritty
  stow_module picom
  stow_module git
}

restore_vscode_extensions() {
  local ext_file="$DOTFILES_DIR/vscode/extensions.txt"

  if ! command -v code >/dev/null 2>&1; then
    warn "Không tìm thấy command code, bỏ qua VSCode extensions."
    return
  fi

  if [ ! -f "$ext_file" ]; then
    warn "Không có $ext_file, bỏ qua VSCode extensions."
    return
  fi

  log "Restoring VSCode extensions..."

  while IFS= read -r ext; do
    [ -z "$ext" ] && continue
    code --install-extension "$ext" || warn "Không cài được extension: $ext"
  done < "$ext_file"
}

setup_default_shell() {
  log "Checking default shell..."

  local zsh_path
  zsh_path="$(command -v zsh)"

  if [ "${SHELL:-}" != "$zsh_path" ]; then
    warn "Shell hiện tại không phải zsh."
    warn "Đổi default shell sang zsh bằng lệnh:"
    echo "  chsh -s $zsh_path"
  else
    log "Default shell already is zsh."
  fi
}

create_common_dirs() {
  log "Creating common directories..."

  mkdir -p "$HOME/.config"
  mkdir -p "$HOME/.local/bin"
  mkdir -p "$HOME/Applications"
  mkdir -p "$HOME/Pictures/Wallpapers"
}

main() {
  require_apt

  log "Starting restore from dotfiles: $DOTFILES_DIR"

  create_common_dirs
  apt_install
  install_oh_my_zsh
  apply_dotfiles
  setup_default_shell

  log "Done."
  echo
  echo "Việc nên làm tiếp:"
  echo "  1. Nếu chưa dùng zsh mặc định: chsh -s \$(command -v zsh)"
  echo "  2. Logout/login lại để shell đổi hiệu lực."
  echo "  3. Reload i3: i3-msg reload && i3-msg restart"
  echo "  4. Nếu stow báo conflict, backup file cũ rồi chạy lại install.sh."
}

main "$@"
