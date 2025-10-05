{ pkgs, lib, ... }:

let
    raw-icon = pkgs.fetchurl {
        url = "https://upload.wikimedia.org/wikipedia/commons/4/4c/Logo_YouTube_%28en_PNG%29.png";
        sha256 = "sha256-Q7dKipztCaSyLAbBkzbZsjNmZ/s4nVCdKnoFAgT2N64=";
    };
    icon = lib.images.cropToContent raw-icon;
in

lib.mkElectronApp {
    inherit icon;
    iconOperations = [
        lib.images.cropToContent
    ];
    appName = "Youtube";
    url = "https://youtube.com";
    description = "Youtube in an electron app";
    extraJavascript = ''
        const cookie = { url: 'https://www.youtube.com', name: 'wide', value: '1' }
        session.defaultSession.cookies.set(cookie)
            .then(() => {
                // success
            }, (error) => {
                console.error(error)
            })
    '';
    adblock = true;
    tray = true;
}
