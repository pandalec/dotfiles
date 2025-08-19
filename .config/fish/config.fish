source ~/.config/fish/functions/common.fish

# starship init fish | source
function starship_transient_prompt_func
    starship module character
end

starship init fish | source
enable_transience
