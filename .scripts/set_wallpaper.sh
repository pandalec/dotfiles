#!/bin/bash

# Define the paths to the wallpaper folders
LIGHT_WALLPAPERS_DIR="$HOME/.wallpapers/light"
DARK_WALLPAPERS_DIR="$HOME/.wallpapers/dark"

# Check if the parameter is provided and valid
if [ "$#" -ne 1 ] || ( [ "$1" != "light" ] && [ "$1" != "dark" ] ); then
    echo "Usage: $0 [light|dark]"
    exit 1
fi

# Select the appropriate folder and gsettings key based on the parameter
if [ "$1" = "light" ]; then
    WALLPAPER_DIR="$LIGHT_WALLPAPERS_DIR"
elif [ "$1" = "dark" ]; then
    WALLPAPER_DIR="$DARK_WALLPAPERS_DIR"
fi

# Check if the selected folder exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "The specified wallpaper folder does not exist: $WALLPAPER_DIR"
    exit 1
fi

# Get a list of wallpaper files in the folder
WALLPAPERS=("$WALLPAPER_DIR"/*)

# Check if there are any wallpapers in the folder
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "No wallpapers found in the specified folder: $WALLPAPER_DIR"
    exit 1
fi

# Choose a random wallpaper from the list
RANDOM_WALLPAPER="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"

# Set light or dark wallpaper per gsettings
if [ "$1" = "light" ]; then
    gsettings set org.gnome.desktop.background picture-uri "file://$RANDOM_WALLPAPER"
elif [ "$1" = "dark" ]; then
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$RANDOM_WALLPAPER"
fi

echo "Wallpaper set to: $RANDOM_WALLPAPER"
