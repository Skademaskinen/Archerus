# https://pathbuilder2e.com/app.html
{ pkgs, lib, ... }:

lib.mkElectronApp {
    appName = "Pathbuilder";
    url = "https://pathbuilder2e.com/app.html";
    icon = pkgs.fetchurl {
        url = "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/fc/c8/09/fcc809c2-c00e-9ba5-ffff-69b917be704f/Placeholder.mill/1200x630wa.jpg";
        sha256 = "sha256-7hPogIqFQiKsQGx+7XTRiRiQQMI1sA4cNHV0RrTVMHY=";
    };
    description = "Pathfinder character sheet App - Electron";
}
