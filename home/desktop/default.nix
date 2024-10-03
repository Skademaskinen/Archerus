{ config, pkgs, lib, ... }:

{
    imports = [
        ./packages.nix
        ../common/alacritty.nix
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

    xsession.windowManager.i3 = import ./i3 {inherit pkgs config lib;};
    services.picom = {
        enable = true;
    };
}
