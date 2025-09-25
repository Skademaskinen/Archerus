{ pkgs, system, nix-gaming, ... }:

{ config, ... }: 

let
    ngpkgs = nix-gaming.packages.${system};
    proton = pkgs.proton-ge-bin;
    wine-tkg = ngpkgs.wine-tkg;
    wine-ge = ngpkgs.wine-ge;
in

{
   home.file = {
       Documents.source = config.lib.file.mkOutOfStoreSymlink "/data/files/Documents";
       Pictures.source = config.lib.file.mkOutOfStoreSymlink "/data/files/Pictures";
       Downloads.source = config.lib.file.mkOutOfStoreSymlink "/data/files/Downloads";
       git.source = config.lib.file.mkOutOfStoreSymlink "/data/files/git";
       Games.source = config.lib.file.mkOutOfStoreSymlink "/data/games";

       # pin proton and wine versions for steam and lutris respectively
       ".local/share/Steam/compatibilitytools.d/Proton-${proton.version}-NixOS".source = (proton.override {
           steamDisplayName = "${proton.version}-NixOS";
       }).steamcompattool;
       ".local/share/lutris/runners/wine/wine-tkg-${wine-tkg.version}-NixOS".source = nix-gaming.packages.${system}.wine-tkg;
       ".local/share/lutris/runners/wine/wine-ge-${wine-ge.version}-NixOS".source = nix-gaming.packages.${system}.wine-ge;

       ".local/share/bolt-launcher/runelite.jar".source = "${pkgs.runelite}/share/RuneLite.jar";
   };
}
