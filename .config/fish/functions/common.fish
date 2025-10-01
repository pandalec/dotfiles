# @fish-lsp-disable-next-line
alias reload="source ~/.config/fish/config.fish"

set -gx EDITOR nvim
set -gx MOZ_ENABLE_WAYLAND 1
set -gx GO111MODULE on

# @fish-lsp-disable-next-line
alias venv=". ansible/venv/bin/activate.fish || . venv/bin/activate.fish || echo 'No venv found'"

set -gx RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"

set -l private_file ~/.config/fish/private.fish
if test -f $private_file
    source $private_file
end

if type -q huenicorn
    # @fish-lsp-disable-next-line
    alias huenistart="systemctl --user start huenicorn"
    # @fish-lsp-disable-next-line
    alias huenirestart="systemctl --user restart huenicorn"
    # @fish-lsp-disable-next-line
    alias huenistop="systemctl --user stop huenicorn"
end

if type -q op
    op completion fish | source
end

if type -q eza
    # @fish-lsp-disable-next-line
    alias ll="eza -l -g --icons --octal-permissions --no-permissions --git --group-directories-first"
    # @fish-lsp-disable-next-line
    alias la="ll -a"
    # @fish-lsp-disable-next-line
    alias lt="ll -T"
    # @fish-lsp-disable-next-line
    alias lta="lt -a"
    # @fish-lsp-disable-next-line
    alias ls="eza -1 --icons --octal-permissions --no-permissions --git --group-directories-first"
end

if type -q kubectl
    # @fish-lsp-disable-next-line
    alias token="kubectl -n kubernetes-dashboard create token admin-user | wl-copy"
end

# @fish-lsp-disable-next-line
function color_title
    # Argument: project/folder name
    set -l title $argv[1]

    # Define the colored emojis
    set -l colors 🟥 🟧 🟨 🟩 🟦 🟪 🟫 ⬛ ⬜ 🔴 🟠 🟡 🟢 🔵 🟣 🟤 ⚫ ⚪ 🔷 🔶 🔹 🔸

    # Normalize to lowercase for consistent hashing
    set -l title_lc (string lower $title)

    # Simple deterministic hash: sum of character codes
    set -l sum 0
    for c in (string split '' $title_lc)
        set -l code (printf "%d" "'$c")
        set sum (math "$sum + $code")
    end

    # Count of colors
    set -l num_colors (count $colors)

    # Pick color index (1-based)
    set -l idx (math "$sum % $num_colors + 1")

    # Return colored title
    echo "$colors[$idx] $title"
end

# @fish-lsp-disable-next-line
function n
    set current_path (pwd)
    cd $HOME

    # Allow multi-selection in fzf
    set folders (fd --type d --hidden --full-path $HOME | fzf --multi --preview 'ls {}')

    if test -n "$folders"
        set first_folder $folders[1]
        set first_foldername (basename $first_folder)
        set first_foldername_colored (color_title $first_foldername)

        # Launch ghostty for additional selections in background
        for folder in $folders[2..-1]
            set foldername (basename $folder)
            set foldername_colored (color_title $foldername)
            ghostty --title="$foldername_colored" --working-directory="$folder" -e nvim >/dev/null 2>&1 &
            disown
        end

        # Now run the first one inline in this shell
        cd "$first_folder"
        echo -ne "\033]0;$first_foldername_colored\007"
        nvim
        cd $HOME
    end

    cd $current_path
end

# @fish-lsp-disable-next-line
function delete_unused
    set unused_packages (pacman -Qdtq)
    if test -n "$unused_packages"
        echo "The following unused packages will be removed:"
        echo "==="
        echo $unused_packages
        echo "==="
        read -P "Press Enter to continue..."
        paru -Rns $unused_packages
    else
        echo "No unused packages to remove."
    end
end

# @fish-lsp-disable-next-line
function fish_greeting
    # echo ""
    # neofetch
end
