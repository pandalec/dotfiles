#!/bin/bash
# Check if the parameter is provided and valid
if [ "$#" -ne 1 ] || ([ "${1}" != "light" ] && [ "${1}" != "dark" ]); then
	echo "Usage: $0 [light|dark]"
	exit 1
fi

# Set wallpaper
~/.scripts/set_wallpaper.sh "${1}"

# Common functions
set_fish() {
	fish -c 'echo y | fish_config theme save $argv[1]' -- "${1}" && fish -c reload
}

set_scooter() {
	sed -i "s/syntax_highlighting_theme = \".*\"/syntax_highlighting_theme = \"${1}\"/" "${HOME}/.dotfiles/.config/scooter/config.toml"
}

set_helix() {
	sed -i "s/theme = \".*\"/theme = \"${1}\"/" "${HOME}/.dotfiles/.config/helix/config.toml"
	pkill -USR1 hx
}

set_yazi() {
	cp "${HOME}/.dotfiles/.config/yazi/theme_${1}.toml" "${HOME}/.dotfiles/.config/yazi/theme.toml"
}

set_kitty() {
	kitten themes --reload-in=all ${1}
}

set_tmux() {
	if [ "${1}" = "light" ]; then
		fg_color='"#6c6f85"'
		bg_color='"#dce0e8"'
		current_bg_color='"#eff1f5"'
		current_fg_color='"#8839ef"'
	else
		fg_color="white"
		bg_color='"#11111b"'
		current_bg_color='"#1e1e2e"'
		current_fg_color='"#cba6f7"'
	fi

	# Set the colors in tmux.conf
	sed -i "s/^set -g status-bg .*/set -g status-bg ${bg_color}/" ~/.dotfiles/.tmux.conf
	sed -i "s/^set -g status-fg .*/set -g status-fg ${fg_color}/" ~/.dotfiles/.tmux.conf
	sed -i "s/^set-window-option -g window-status-current-style fg=.*,bg=.*/set-window-option -g window-status-current-style fg=${current_fg_color},bg=${current_bg_color}/" ~/.dotfiles/.tmux.conf

	tmux source-file ~/.tmux.conf || true
}

set_dark() {
	set_scooter "Catppuccin Mocha"
	set_fish "Catppuccin Mocha"
	# set_helix "catppuccin_mocha"
	# set_tmux "dark"
	set_yazi "dark" || true
	gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' # paru -S adw-gtk-theme
	gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
}

set_light() {
	set_scooter "Catppuccin Latte"
	set_fish "Catppuccin Latte" || true
	# set_helix "catppuccin_latte" || true
	# set_tmux "light" || true
	set_yazi "light" || true
	gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'
	gsettings set org.gnome.desktop.interface color-scheme 'default'
}

# Set additional settings
if [ "${1}" = "light" ]; then
	set_light || true
elif [ "${1}" = "dark" ]; then
	set_dark || true
fi
