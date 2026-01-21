#!/usr/bin/env bash
set -euo pipefail

TIMESTAMP="$(date +%Y%m%d%H%M%S)"
SUDO=""
if [ "$EUID" -ne 0 ]; then
	SUDO=sudo
fi

info() { printf "[INFO] %s\n" "$*"; }
warn() { printf "[WARN] %s\n" "$*"; }
err() { printf "[ERROR] %s\n" "$*"; exit 1; }

detect_distro() {
	if command -v apt >/dev/null 2>&1; then
		echo "apt"
	else
		echo "unknown"
	fi
}

PKG_MANAGER=$(detect_distro)
if [ "$PKG_MANAGER" != "apt" ]; then
	err "Unsupported package manager. This script currently supports Debian/Ubuntu (apt)."
fi

info "Updating package lists"
${SUDO} apt update -y

COMMON_PACKAGES=(wget gpg apt-transport-https build-essential git bat zsh autojump lsd meld)
info "Installing base packages: ${COMMON_PACKAGES[*]}"
${SUDO} apt install -y "${COMMON_PACKAGES[@]}"

if grep -qi microsoft /proc/version 2>/dev/null; then
	info "Detected WSL; recommended to run this script inside your WSL distro terminal."
fi

# Install or ensure Oh My Zsh is present
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	info "Installing Oh My Zsh (non-interactive)"
	RUNZSH=no CHSH=no sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
	info "Oh My Zsh already installed"
fi

# Install Powerlevel10k theme
P10K_DIR="$ZSH_CUSTOM_DIR/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
	info "Installing Powerlevel10k"
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
	info "Powerlevel10k already present"
fi

# Safe copy helper: backup existing file if present
safe_copy() {
	src="$1"; dest="$2"
	if [ -e "$dest" ]; then
		info "Backing up existing $dest -> ${dest}.bak.$TIMESTAMP"
		mv "$dest" "${dest}.bak.$TIMESTAMP"
	fi
	cp -r "$src" "$dest"
}

info "Copying config files"
if [ -e "aliases" ]; then
	safe_copy "aliases" "$HOME/.aliases"
fi
if [ -e "zsh/zshrc" ]; then
	safe_copy "zsh/zshrc" "$HOME/.zshrc"
fi
if [ -e "zsh/custom-p10k.zsh" ]; then
	safe_copy "zsh/custom-p10k.zsh" "$P10K_DIR/.p10k.zsh"
fi

# Zsh plugins
ZSH_PLUGINS_DIR="$ZSH_CUSTOM_DIR/plugins"
mkdir -p "$ZSH_PLUGINS_DIR"
install_plugin() {
	repo="$1"; name="$2"
	target="$ZSH_PLUGINS_DIR/$name"
	if [ ! -d "$target" ]; then
		info "Installing plugin $name"
		git clone --depth=1 "$repo" "$target"
	else
		info "Plugin $name already installed"
	fi
}
install_plugin https://github.com/zsh-users/zsh-autosuggestions.git zsh-autosuggestions
install_plugin https://github.com/zsh-users/zsh-syntax-highlighting.git zsh-syntax-highlighting

# Install git templates/hooks so new repos inherit the commit-msg hook
GIT_TEMPLATE_DIR="$HOME/.git-templates"
mkdir -p "$GIT_TEMPLATE_DIR/hooks"
if [ -f git/.hooks/commit-msg ]; then
	info "Installing git commit-msg hook template"
	cp git/.hooks/commit-msg "$GIT_TEMPLATE_DIR/hooks/commit-msg"
	chmod +x "$GIT_TEMPLATE_DIR/hooks/commit-msg"
	git config --global init.templateDir "$GIT_TEMPLATE_DIR" || warn "Failed to set global git init.templateDir"
fi

# Copy user-level git configs if present
if [ -f git/.gitconfig ]; then
	safe_copy "git/.gitconfig" "$HOME/.gitconfig"
fi
if [ -f git/.gitattributes ]; then
	safe_copy "git/.gitattributes" "$HOME/.gitattributes"
fi

# Optional: add PPA for diff-so-fancy if available
if command -v add-apt-repository >/dev/null 2>&1; then
	info "Adding PPA for diff-so-fancy and installing it"
	${SUDO} add-apt-repository -y ppa:aos1/diff-so-fancy || warn "Could not add PPA; continuing"
	${SUDO} apt update -y || true
	${SUDO} apt install -y diff-so-fancy || warn "diff-so-fancy install failed"
else
	info "add-apt-repository not available; skipping diff-so-fancy PPA step"
fi

info "Setup complete. Review backups: files ending with .bak.$TIMESTAMP"
info "Open a new terminal (or run 'exec zsh') to start using zsh and Powerlevel10k."
