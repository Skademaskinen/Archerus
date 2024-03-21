{pkgs}: let

in pkgs.stdenv.mkDerivation rec {
    name = "warcraftlogsuploader";
    pname = "warcraftlogsuploader";
    version = "8.3.16";
    src = pkgs.fetchurl {
        url = "https://github.com/RPGLogs/Uploaders-warcraftlogs/releases/download/v${version}/warcraftlogs-v${version}.AppImage";
        sha256 = "sha256-1IgsofoVXJfCrIjzXGclTmKwK/hMQlTrR9Y8KTMJNEA=";
    }; 
    dontUnpack = true;
    installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/share/warcraftlogsuploader
        mkdir -p $out/share/applications
        cp $src $out/share/warcraftlogsuploader/warcraftlogs.AppImage
        chmod +x $out/share/warcraftlogsuploader/warcraftlogs.AppImage

        
        echo "#!${pkgs.bash}/bin/bash" >> $out/bin/warcraftlogsuploader
        echo "${pkgs.appimage-run}/bin/appimage-run $out/share/warcraftlogsuploader/warcraftlogs.AppImage" >> $out/bin/warcraftlogsuploader

        chmod +x $out/bin/warcraftlogsuploader

        cat >> $out/share/applications/warcraftlogsuploader.desktop << EOF
            [Desktop Entry]
            Name=Warcraft Logs Uploader
            Exec=$out/bin/warcraftlogsuploader
            Terminal=false
            Type=Application
            StartupWMClass=Warcraft Logs Uploader
            Comment=Warcraft Logs Uploader
            Categories=Game;
        EOF
    '';

}
