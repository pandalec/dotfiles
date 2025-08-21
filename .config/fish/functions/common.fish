# @fish-lsp-disable-next-line
alias reload="source ~/.config/fish/config.fish"

set -gx EDITOR nvim
set -gx MOZ_ENABLE_WAYLAND 1

# @fish-lsp-disable-next-line
alias venv=". ansible/venv/bin/activate.fish || . venv/bin/activate.fish || echo 'No venv found'"

set -gx RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"

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
function nfs
    set current_path (pwd)
    cd $HOME
    set folder "$(fd --type d --hidden --full-path $HOME | fzf --preview 'ls {}' | awk '{$1=$1} 1')"
    set foldername "$(basename $folder)"
    cd "$folder"
    echo -ne "\033]0;$foldername\007"
    if test -n "$folder"
        nvim
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
        echo $unused_packages | paru -Rns -
    else
        echo "No unused packages to remove."
    end
end

# @fish-lsp-disable-next-line
function fish_greeting
    # echo ""
    # neofetch
end
