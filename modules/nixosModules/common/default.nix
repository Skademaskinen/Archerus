inputs:

{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        vim
    ];
    networking.networkmanager.enable = true;

}
