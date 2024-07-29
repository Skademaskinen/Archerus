{pkgs, lib, ...}: let
    tools = import ../tools.nix { inherit pkgs lib; };
in bukkit-options: with bukkit-options; with tools; pkgs.writeText "bukkit.yml" (nix2yml bukkit-options)