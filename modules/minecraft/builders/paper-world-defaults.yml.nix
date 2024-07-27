{pkgs, lib, ...}: let
    tools = import ../tools.nix { inherit pkgs lib; };
in opts: with opts; with tools; pkgs.writeText "paper-world-defaults.yml" (nix2yml opts)