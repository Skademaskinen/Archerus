{ lib, ... }:

lib.mkElectronApp {
    appName = "Fikien";
    url = "https://fklub.dk";
    icon = lib.wallpapers.flogo-inverted;
    description = "F-klubbens Fiki";
}
