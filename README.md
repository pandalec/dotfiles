# .dotfiles

## Introduction

Personal configuration files for my Arch Linux (btw) environment, optimized for a **consistent light/dark theme** across all tools and applications.  
Dark mode uses **Catppuccin Mocha**, light mode uses **Catppuccin Latte**. Tools like **Yazi**, **Scooter**, and **Lazygit** are integrated with Neovim for a unified experience.

## Structure

### `.config/`

- **bat/** – Syntax highlighting themes (Catppuccin Latte/Mocha)
- **fish/** – Shell configuration, completions, functions, themes
- **ghostty/** – Terminal configuration
- **lazygit/** – Lazygit config + dark/light themes
- **nvim/** – Neovim setup with Lua modules, plugins, keymaps, and options
- **paru/** – Package manager configuration
- **scooter/** – App theming configuration
- **yazi/** – File manager configuration, keymaps, and theme files
- **starship.toml** – Shell prompt configuration

### `.scripts/`

- **set_theme.sh** – Switches light/dark themes across all tools
- **set_wallpaper.sh** – Sets wallpaper based on screen resolution and theme

### Other dotfiles

- `.gitattributes`
- `.gitignore`
- `.ripgreprc`
- `.stow-local-ignore`
- `.gkr`

## Theme Switching

The main goal of these scripts is to maintain **consistent theming** across the desktop and terminal environment.

### `.scripts/set_theme.sh`

- Triggered by the **Night Theme Switcher GNOME Extension**
- Accepts one argument: `light` or `dark`
- Updates configuration and themes for:
  - Fish shell (`fish_config`)
  - Scooter (`config.toml`)
  - Bat syntax highlighting
  - JiraTUI, if available (`config.yaml`)
  - Lazygit (`config.yml`)
  - Yazi file manager (`theme.toml`)
  - GTK theme via `gsettings`
- Calls `.scripts/set_wallpaper.sh` to sync wallpaper with theme

### `.scripts/set_wallpaper.sh`

- Detects current screen resolutions across connected monitors
- Chooses a wallpaper from the appropriate folder:
  - `~/.wallpapers/<width>x<height>/light/`
  - `~/.wallpapers/<width>x<height>/dark/`
- Sets the wallpaper via `gsettings` (light or dark)

Together, these scripts unify theming across terminal tools, GUI apps, and wallpapers.

## Usage

Clone and apply dotfiles using GNU Stow:

```bash
git clone https://github.com/pandalec/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow .
```

Install [paru](https://github.com/Morganamilo/paru) and install software

```bash
paru -S --needed \
    bat \
    eza \
    fd \
    fish \
    fzf \
    ghostty \
    git-delta \
    go-yq \
    htop \
    jiratui-git \
    kotlin \
    kubectl \
    lazydocker \
    lazygit \
    less \
    neofetch \
    neovim-nightly-bin \
    paru-bin \
    repgrep \
    rustup \
    scooter \
    starship \
    stow \
    ueberzugpp \
    wget \
    wl-clipboard \
    yazi
```

Switch themes manually:

```bash
~/.scripts/set_theme.sh light   # Apply light mode
~/.scripts/set_theme.sh dark    # Apply dark mode
```

## Notes

- Tailored for my personal workflow
- Review configurations before applying to a new system
- Themes, scripts, and Neovim integrations are optimized for visual consistency
