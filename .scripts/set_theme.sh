#!/bin/bash

# This script is run by Night Theme Switcher (GNOME Extension)

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

set_yazi() {
	cp -f "${HOME}/.dotfiles/.config/yazi/theme_${1}.toml" "${HOME}/.dotfiles/.config/yazi/theme.toml"
	# Delete backup files
	rm -f ${HOME}/.dotfiles/.config/yazi/*-[0-9]*
}

set_dark() {
	set_scooter "Catppuccin Mocha"
	set_fish "Catppuccin Mocha"
	set_yazi "dark" || true
	gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' # paru -S adw-gtk-theme
	gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
}

set_light() {
	set_scooter "Catppuccin Latte"
	set_fish "Catppuccin Latte" || true
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
