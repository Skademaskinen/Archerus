{ pkgs, lib, ... }:

let
    raw-icon = pkgs.fetchurl {
        url = "https://upload.wikimedia.org/wikipedia/commons/1/13/ChatGPT-Logo.png";
        sha256 = "sha256-H5iLGsKk47vd2K6QdmzST3faX+jHs3Rzhyv+Pd9UMa8=";
    };
    icon = lib.images.cropToContent "ChatGPT.png" (lib.images.invert "ChatGPT.png" raw-icon);
in

lib.mkElectronApp {
    inherit icon;
    appName = "ChatGPT";
    url = "https://chat.openai.com";
    description = "ChatGPT in an electron app";
}
