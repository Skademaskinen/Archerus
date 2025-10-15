{ pkgs, system, nix-gaming, ... }:

{ config, ... }: 

let
    ngpkgs = nix-gaming.packages.${system};
    proton = ((pkgs.proton-ge-bin.overrideAttrs rec {
        version = "GE-Proton10-18";
        src = pkgs.fetchzip {
            url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
            hash = "sha256-s2xnoyRy4JI1weRJ+9wjZzBRpsH7HMbK9DbhdVDJKww=";
        };
    }).override { steamDisplayName = "${pkgs.proton-ge-bin.version}-NixOS"; }).steamcompattool;
    wine-tkg = ngpkgs.wine-tkg.overrideAttrs { name = "wine-tkg-${ngpkgs.wine-tkg.version}-NixOS"; };
    wine-ge = ngpkgs.wine-ge.overrideAttrs { name = "wine-tkg-${ngpkgs.wine-ge.version}-NixOS"; };
in

{
   home.file = {
       Documents.source = config.lib.file.mkOutOfStoreSymlink "/data/files/Documents";
       Pictures.source = config.lib.file.mkOutOfStoreSymlink "/data/files/Pictures";
       Downloads.source = config.lib.file.mkOutOfStoreSymlink "/data/files/Downloads";
       git.source = config.lib.file.mkOutOfStoreSymlink "/data/files/git";
       Games.source = config.lib.file.mkOutOfStoreSymlink "/data/games";

       # pin proton and wine versions for steam and lutris respectively
       ".local/share/Steam/compatibilitytools.d/${proton.version}-NixOS".source = proton;
       ".local/share/lutris/runners/wine/wine-tkg-${wine-tkg.version}-NixOS".source = wine-tkg;
       ".local/share/lutris/runners/wine/wine-ge-${wine-ge.version}-NixOS".source = wine-ge;
       ".local/share/lutris/runners/proton/${proton.version}-NixOS".source = proton;

       ".local/share/bolt-launcher/runelite.jar".source = "${pkgs.runelite}/share/RuneLite.jar";
   };
}
