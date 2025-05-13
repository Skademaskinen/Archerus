inputs:

with builtins;

listToAttrs (map (name: {
    name = name;
    value = import (toPath "${./.}/${name}.nix") inputs;
}) [
    "common"
    "hyprland"
    "nixvim"
    "sway"
    "programming"
    "zsh"
    "alacritty"
])
