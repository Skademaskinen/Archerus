{ pkgs, lib, ... }:

lib.mkElectronApp {
    iconOperations = [
        lib.images.cropToContent
    ];
    iconSha256 = "sha256:1lpdnf47nxqnl7693ynzlafp50mm7agybf118bn2vl6g96cm99j3";
    appName = "Discord";
    url = "https://discord.com/app";
    description = "Discord in an electron app";
}
