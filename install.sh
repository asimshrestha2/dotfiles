#!/usr/bin/bash

error() { echo "${red}ERROR:${plain} $*"; exit 1; }
available() { command -v $1 >/dev/null; }

echo "Installing programs and dotfiles"

. /etc/os-release

OS_NAME=$ID

SUDO=
if [ "$(id -u)" -ne 0 ]; then
	# Running as root, no need for sudo
	if ! available sudo; then
		error "This script requires superuser permissions. Please re-run as root."
	fi

	SUDO="sudo"
fi

case $OS_NAME in
	arch)
		yay -S --needed --noconfirm gcc make unzip rsync \
			fd tldr zoxide ripgrep fzf bat fastfetch htop firefox librewolf-bin \
			flatpak mission-center kdeconnect blender vlc mpv ffmpeg fish ghostty \
			steam git libreoffice-fresh keepassxc neovim tmux
	;;
	debian|ubuntu) 
		$SUDO add-apt-repository ppa:neovim-ppa/unstable -y
		$SUDO apt update
		$SUDO apt -y install tmux fastfetch make gcc ripgrep unzip git xclip neovim
	;;
	*) exit ;;
esac

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub -y com.heroicgameslauncher.hgl com.discordapp.Discord \
	org.signal.Signal com.obsproject.Studio com.protonvpn.www \
	com.nextcloud.desktopclient.nextcloud

# Nvim config
git clone https://github.com/asimshrestha2/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

