{ config, pkgs, lib, ... }:

{
    imports = [
        ./packages.nix
        ../common
    ];
    home.username = "mast3r";
    home.homeDirectory = "/home/mast3r";

    home.stateVersion = "24.05";

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
