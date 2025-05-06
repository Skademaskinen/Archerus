{pkgs, ...}: let
    myMage = pkgs.xmage.overrideAttrs {
        src = pkgs.fetchurl {
            url = "http://xmage.today/files/mage-full_1.4.56-dev_2025-02-09_16-07.zip";
            sha256 = "sha256-zpCUDApYZXHDEjwFOtg+L/5Es4J96F4Z2ojFcrzYumo=";
        };
    };
in {
    environment.systemPackages = with pkgs; [
        gnupg
        cinny-desktop
        (pkgs.writeScriptBin "mage-server" ''
            #!${bash}/bin/bash
            cd $1
            ${jdk8}/bin/java -jar ${myMage}/xmage/mage-server/lib/mage-server-1.4.56.jar
        '')
        (pkgs.writeScriptBin "mage-client" ''
            #!${bash}/bin/bash
            cd $1
            _JAVA_AWT_WM_NONREPARENTING=1 ${jdk8}/bin/java -jar ${myMage}/xmage/mage-client/lib/mage-client-1.4.56.jar
        '')
        wireshark-qt
        (pkgs.callPackage ./programs/wine-discord-ipc-bridge.nix {})
    ];
    nixpkgs.config.permittedInsecurePackages = [
        "cinny-4.2.3"
        "cinny-unwrapped-4.2.3"
    ];


}
