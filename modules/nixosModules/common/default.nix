inputs:

{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        vim
    ];
    networking.networkmanager.enable = true;

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    fonts.packages = with pkgs; [
        fira
        fira-mono
        nerdfonts
    ];
}
