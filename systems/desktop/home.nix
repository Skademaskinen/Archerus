{ config, pkgs, ... }:

{
    imports = [
        ./packages.nix
        ./i3.nix
    ];
    home.username = "mast3r";
    home.homeDirectory = "/home/mast3r";

    home.stateVersion = "24.05";

    home.sessionVariables = {
        EDITOR="nvim";
        PROMPT="%F{166}%n%f@%F{166}%m%f %F{7}%~%f%F{166} > %f";
    };
    home.sessionPath = [
        "$HOME/.local/bin"
    ];
    nixpkgs.config.allowUnfree = true;

    programs.home-manager.enable = true;
}