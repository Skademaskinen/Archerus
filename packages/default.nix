{ lib, system, ... }:

{
    ${system} = lib.mkSubmodules [
        ./testDesktop
        ./testServer
        ./plymouth-theme
        ./plymouth-theme-default
        ./wine-discord-ipc-bridge
        ./curseforge
        ./lavalink

        # tools
        ./projectTools
        ./initializer
        
        # projects
        ./homepage
        ./folkevognen
        ./putricide
        ./rp-utils
        ./sketch-bot

        # package sets
        ./steamPackages
    ] // {
        default = lib.load ./initializer;
};
}
