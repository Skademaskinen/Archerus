{ lib, ... }:

lib.mkElectronApp {
    appName = "Stregsystemet";
    url = "https://stregsystemet.fklub.dk";
    icon = lib.wallpapers.flogo-inverted;
    description = "F-klubbens stregsystem";
}
