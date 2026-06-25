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
    polybar \
    tmux \
    rofi \
    dunst \
    libnotify-bin \
    pulseaudio-utils \
    pavucontrol \
    playerctl \
    brightnessctl \
    kitty \
    feh \
    picom \
    xclip \
    xsel \
    network-manager-gnome \
    blueman \
    fonts-font-awesome \
    papirus-icon-theme\
    fonts-jetbrains-mono \
    zsh \
    fzf \
    command-not-found \
    ripgrep \
    fd-find \
    luarocks \
    python3-pip \
    python3-venv \
    cmake \
    pkg-config \
    fcitx5 \
    fcitx5-unikey \
    fcitx5-frontend-gtk4 \
    fcitx5-frontend-gtk3 \
    fcitx5-frontend-qt5 \
    fcitx5-config-qt \
    im-config \
    keychain

}

remove_snap() {
  log "Removing snap and snapd..."

  if ! command -v snap >/dev/null 2>&1 && ! dpkg -l snapd >/dev/null 2>&1; then
    log "Snap already removed."
    return
  fi

  # Remove installed snaps. Some snaps depend on others (e.g. core/bases),
  # so loop until nothing is left rather than relying on a single pass.
  if command -v snap >/dev/null 2>&1; then
    local attempts=0
    while [ "$attempts" -lt 10 ]; do
      local snaps
      snaps="$(snap list 2>/dev/null | awk 'NR>1 {print $1}')"
      [ -z "$snaps" ] && break

      local s
      for s in $snaps; do
        sudo snap remove --purge "$s" 2>/dev/null || true
      done
      attempts=$((attempts + 1))
    done
  fi

  # Stop and purge snapd itself.
  sudo systemctl stop snapd.socket snapd.service 2>/dev/null || true
  sudo apt purge -y snapd || true
  sudo apt-mark hold snapd 2>/dev/null || true

  # Clean up leftover snap directories.
  sudo rm -rf /var/cache/snapd
  rm -rf "$HOME/snap"

  # Block snapd from being reinstalled as a dependency.
  sudo tee /etc/apt/preferences.d/nosnap.pref >/dev/null <<'EOF'
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

  log "Snap removed and pinned so it won't be reinstalled."
}

install_firefox() {
  log "Installing Firefox (deb from Mozilla APT repo)..."

  if command -v firefox >/dev/null 2>&1 && ! firefox --version 2>/dev/null | grep -qi snap; then
    log "Firefox already installed."
    return
  fi

  sudo install -d -m 0755 /etc/apt/keyrings

  wget -qO- https://packages.mozilla.org/apt/repo-signing-key.gpg \
    | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc >/dev/null

  echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" \
    | sudo tee /etc/apt/sources.list.d/mozilla.list >/dev/null

  # Prefer the Mozilla repo over the Ubuntu snap-transitional firefox package.
  sudo tee /etc/apt/preferences.d/mozilla >/dev/null <<'EOF'
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
EOF

  sudo apt update
  sudo apt install -y firefox
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

install_nerd_fonts() {
  log "Installing JetBrainsMono Nerd Font..."

  local font_dir="$HOME/.local/share/fonts"

  if fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd Font"; then
    log "JetBrainsMono Nerd Font already installed."
    return
  fi

  mkdir -p "$font_dir"

  local tmp
  tmp="$(mktemp -d)"
  local url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"

  if curl -fsSLo "$tmp/JetBrainsMono.zip" "$url"; then
    unzip -o -q "$tmp/JetBrainsMono.zip" -d "$font_dir/JetBrainsMonoNerd" \
      && fc-cache -f "$font_dir" >/dev/null \
      && log "JetBrainsMono Nerd Font installed."
  else
    warn "Không tải được JetBrainsMono Nerd Font, polybar sẽ thiếu icon. Cài thủ công từ nerd-fonts."
  fi

  rm -rf "$tmp"
}

install_neovim() {
  log "Installing Neovim (latest stable)..."

  if command -v nvim >/dev/null 2>&1; then
    log "Neovim already installed."
    return
  fi

  local tmp
  tmp="$(mktemp -d)"
  curl -fsSLo "$tmp/nvim-linux-x86_64.tar.gz" \
    "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
  sudo tar -xzf "$tmp/nvim-linux-x86_64.tar.gz" --strip-components=1 -C /usr/local
  rm -rf "$tmp"
}

install_nodejs() {
  log "Installing Node.js LTS (via NodeSource)..."

  if command -v node >/dev/null 2>&1; then
    log "Node.js already installed ($(node --version))."
    return
  fi

  curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
  sudo apt install -y nodejs
}

install_lazygit() {
  log "Installing lazygit (latest stable)..."

  if command -v lazygit >/dev/null 2>&1; then
    log "lazygit already installed."
    return
  fi

  local version
  version="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
    | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')"

  local tmp
  tmp="$(mktemp -d)"
  curl -fsSLo "$tmp/lazygit.tar.gz" \
    "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${version}_Linux_x86_64.tar.gz"
  tar -xzf "$tmp/lazygit.tar.gz" -C "$tmp" lazygit
  sudo install "$tmp/lazygit" /usr/local/bin/lazygit
  rm -rf "$tmp"
}

setup_fd_symlink() {
  # fd-find installs as 'fdfind' on Debian/Ubuntu; LazyVim expects 'fd'
  if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    log "Created fd -> fdfind symlink in ~/.local/bin"
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

override_conflicts() {
  local module="$1"
  local src="$DOTFILES_DIR/$module"

  # For each file the module deploys, drop any existing real file/dir at the target
  # so stow can replace it with its symlink. Skip anything that already resolves into
  # the dotfiles repo (a direct stow symlink, or a file inside a folded directory
  # symlink) — those are already managed by stow and must NOT be deleted.
  while IFS= read -r -d '' file; do
    local rel="${file#"$src"/}"
    local target="$HOME/$rel"

    # Nothing there (and not a dangling symlink) -> stow handles it.
    [ -e "$target" ] || [ -L "$target" ] || continue

    # Already pointing into the repo? Leave it for stow --restow.
    local real
    real="$(realpath -m "$target" 2>/dev/null || printf '%s' "$target")"
    case "$real/" in
      "$DOTFILES_DIR"/*) continue ;;
    esac

    # Genuine user file/dir -> override it.
    warn "Overriding existing $target"
    rm -rf "$target"
  done < <(find "$src" -type f -print0)
}

stow_module() {
  local module="$1"

  if [ -d "$DOTFILES_DIR/$module" ]; then
    log "Stowing $module..."
    override_conflicts "$module"
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
  stow_module i3status
  stow_module polybar
  stow_module rofi
  stow_module dunst
  stow_module tmux
  stow_module zsh
  stow_module scripts
  stow_module kitty
  stow_module picom
  stow_module git
  stow_module nvim
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

setup_fcitx5() {
  log "Setting up fcitx5 + Unikey (Vietnamese input)..."

  local profile="$HOME/.profile"
  touch "$profile"

  # IM environment variables — needed so GUI apps pick up fcitx5.
  # Appended idempotently so re-running install.sh doesn't duplicate them.
  local line
  for line in \
    "export GTK_IM_MODULE=fcitx" \
    "export QT_IM_MODULE=fcitx" \
    "export XMODIFIERS=@im=fcitx"; do
    if ! grep -qxF "$line" "$profile"; then
      echo "$line" >> "$profile"
      log "Added to ~/.profile: $line"
    fi
  done

  # Select fcitx5 as the active input method framework for the X session.
  if command -v im-config >/dev/null 2>&1; then
    im-config -n fcitx5
  else
    warn "Không có im-config, bỏ qua. fcitx5 vẫn được autostart trong i3 (fcitx5 -d)."
  fi

  log "fcitx5 đã cài. Logout/login lại, rồi dùng fcitx5-config-qt để thêm Unikey nếu chưa có."
}

create_common_dirs() {
  log "Creating common directories..."

  mkdir -p "$HOME/.config"
  mkdir -p "$HOME/.local/bin"
  mkdir -p "$HOME/Applications"
  mkdir -p "$HOME/Pictures/Wallpapers"
}

install_wallpaper() {
  log "Downloading wallpaper..."

  local dest="$HOME/Pictures/Wallpapers/wallpaper.jpg"

  if [ -f "$dest" ]; then
    log "Wallpaper already exists at $dest."
    return
  fi

  mkdir -p "$HOME/Pictures/Wallpapers"

  # Catppuccin-themed wallpapers. First reachable URL wins.
  local urls=(
    "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/main/landscapes/evening-sky.png"
    "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/main/minimalistic/mocha_cat.png"
  )

  local u
  for u in "${urls[@]}"; do
    if curl -fsSL --max-time 30 -o "$dest" "$u"; then
      log "Wallpaper downloaded to $dest."
      return
    fi
  done

  warn "Không tải được wallpaper. Tự bỏ ảnh vào $dest (i3 trỏ tới path này)."
}

main() {
  require_apt

  log "Starting restore from dotfiles: $DOTFILES_DIR"

  create_common_dirs
  apt_install
  install_wallpaper
  remove_snap
  install_firefox
  install_nerd_fonts
  install_neovim
  install_nodejs
  install_lazygit
  setup_fd_symlink
  install_oh_my_zsh
  apply_dotfiles
  setup_default_shell
  setup_fcitx5

  log "Done."
  echo
  echo "Việc nên làm tiếp:"
  echo "  1. Nếu chưa dùng zsh mặc định: chsh -s \$(command -v zsh)"
  echo "  2. Logout/login lại để shell đổi hiệu lực."
  echo "  3. Reload i3: i3-msg reload && i3-msg restart"
  echo "  4. Nếu stow báo conflict, backup file cũ rồi chạy lại install.sh."
  echo "  5. Gõ tiếng Việt: logout/login, mở fcitx5-config-qt thêm Unikey,"
  echo "     rồi chuyển input bằng Ctrl+Space."
  echo "  6. Mở nvim lần đầu để LazyVim tự cài plugins (mất ~1 phút)."
}

main "$@"
