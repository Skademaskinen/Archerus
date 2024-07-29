{pkgs, lib, ...}: let
    tools = import ../tools.nix { inherit pkgs lib; };

in paper-global-settings: with paper-global-settings; with tools; pkgs.writeText "paper-global.yml" (nix2yml paper-global-settings)