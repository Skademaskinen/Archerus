{ pkgs, config, lib, ... }:

{
    imports = [
        ../common/alacritty.nix
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
    ];

    wayland.windowManager.sway = import ./sway {inherit pkgs config lib;};
    programs.swaylock.enable = true;
    programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        theme = "sidebar";
    };

    nixpkgs.config.allowUnfree = true;
    programs.neovim.enable = true;
    
    home.file = {
    };
    
    home.sessionVariables = {
        EDITOR="nvim";
        PROMPT="%F{166}%n%f@%F{166}%m%f %F{7}%~%f%F{166} λ %f";
    };

    programs.home-manager.enable = true;
}
