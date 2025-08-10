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

        # maintenance
        ./projectTools
        
        # projects
        ./homepage
        ./folkevognen
        ./putricide
        ./rp-utils
        ./sketch-bot
    ];
}

