{ lib, pkgs, ... }:

let
    electron = pkgs.electron_38-bin;
    appName = "chatgpt-electron";
    userDataDir = "$HOME/.local/share/${appName}";

    logo = pkgs.fetchurl {
      url = "https://upload.wikimedia.org/wikipedia/commons/1/13/ChatGPT-Logo.png";
      sha256 = "sha256-H5iLGsKk47vd2K6QdmzST3faX+jHs3Rzhyv+Pd9UMa8=";
    };
    logo-inverted = lib.images.cropToContent "ChatGPT-Logo.png" (lib.images.invert "ChatGPT-Logo.png" logo);
in

pkgs.stdenv.mkDerivation {
    pname = appName;
    version = "1.0.1";

    src = null;
    dontUnpack = true;

    buildInputs = [ pkgs.makeWrapper ];

    installPhase = ''
        mkdir -p $out/bin
        makeWrapper ${electron}/bin/electron $out/bin/${appName} \
            --add-flags "https://chat.openai.com" \
            --add-flags "--ozone-platform=wayland" \
            --add-flags "--enable-features=UseOzonePlatform,WaylandWindowDecorations,VaapiVideoDecoder" \
            --add-flags "--user-data-dir=${userDataDir}" \
            --add-flags "--disk-cache-dir=${userDataDir}/cache"

            # desktop entry
            mkdir -p $out/share/applications
            cp ${pkgs.writeText "${appName}.desktop" ''
                [Desktop Entry]
                Name=ChatGPT
                Exec=${appName}
                Icon=${appName}
                Type=Application
                Categories=Network;Chat
                StartupNotify=true
            ''} $out/share/applications/${appName}.desktop

            # icon (official logo in PNG/SVG)
            mkdir -p $out/share/icons/hicolor/512x512/apps
            cp ${logo-inverted} $out/share/icons/hicolor/512x512/apps/${appName}.svg
  '';
}

