{ pkgs, config, lib, ... }:

{
    imports = [
        ../common
    ];
    home.username = "mast3r";
    home.homeDirectory = "/home/mast3r";
    home.stateVersion = "24.05";
    home.packages = with pkgs; [
        firefox
        discord
        thunderbird
        hyfetch
        rofi-wayland
        cinny-desktop
        tigervnc
        element-desktop
	    teams-for-linux
        signal-desktop
        okular
    ];

    wayland.windowManager.sway = import ./sway {inherit pkgs config lib;};
    programs.swaylock.enable = false;
    programs.swaylock.settings = {
        show-failed-attempts = true;
        ignore-empty-password = true;

    };
    programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        theme = "sidebar";
    };

    nixpkgs.config.allowUnfree = true;
    programs.neovim.enable = true;
    
    home.file = {
    };

    programs.home-manager.enable = true;
}
