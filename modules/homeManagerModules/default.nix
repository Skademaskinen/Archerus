inputs:

with builtins;

listToAttrs (map (name: {
    name = name;
    value = import (toPath "${./.}/${name}") inputs;
}) [
    "common"
    "hyprland"
    "neovim"
    "sway"
    "zsh"
    "alacritty"
    "kitty"
])
