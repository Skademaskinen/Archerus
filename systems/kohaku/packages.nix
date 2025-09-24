{ pkgs, ... }:

{
    environment.systemPackages = [
        pkgs.fastfetch
        pkgs.teams-for-linux
        pkgs.gimp
        pkgs.kdePackages.okular
        pkgs.vlc
        pkgs.linuxPackages.nvidiaPackages.latest.lib32
    ];
}
