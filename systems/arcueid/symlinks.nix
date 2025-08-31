{ system, nix-gaming, ... }:

{ config, pkgs, ... }: 

{
   home.file = {
       Documents.source = config.lib.file.mkOutOfStoreSymlink "/data/files/Documents";
       Pictures.source = config.lib.file.mkOutOfStoreSymlink "/data/files/Pictures";
       Downloads.source = config.lib.file.mkOutOfStoreSymlink "/data/files/Downloads";
       git.source = config.lib.file.mkOutOfStoreSymlink "/data/files/git";
       Games.source = config.lib.file.mkOutOfStoreSymlink "/data/games";

       # pin proton and wine versions for steam and lutris respectively
       ".local/share/Steam/compatibilitytools.d/Proton-NixOS".source = (pkgs.proton-ge-bin.override {
           steamDisplayName = "GE-Proton-NixOS";
       }).steamcompattool;
       ".local/share/lutris/runners/wine/wine-tkg-NixOS".source = nix-gaming.packages.${system}.wine-tkg;
       ".local/share/lutris/runners/wine/wine-ge-NixOS".source = nix-gaming.packages.${system}.wine-ge;
   };
}
