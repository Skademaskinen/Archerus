{ pkgs, lib, ... }:

lib.mkElectronApp {
    appName = "Nixos-Packages";
    url = "https://search.nixos.org/packages";
    icon = "${pkgs.nixos-icons}/share/icons/hicolor/512x512/apps/nix-snowflake.png";
    description = "Nixos Package search";
}
