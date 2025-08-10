{ lib, ... }:

lib.mkSubmodules [
    ./common
    ./hyprland
    ./neovim
    ./sway
    ./zsh
    ./alacritty
    ./kitty
]
