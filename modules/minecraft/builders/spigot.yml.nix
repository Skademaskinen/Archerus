{pkgs, lib, ...}: let
    tools = import ../tools.nix { inherit pkgs lib; };
in spigot-options: with spigot-options; with tools; pkgs.writeText "spigot.yml" (nix2yml spigot-options)