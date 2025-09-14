{ pkgs, ... }:

let
    name = "warcraftlogs";
    pname = name;
    version = "v8.17.51";
    src = builtins.fetchurl {
        url = "https://github.com/RPGLogs/Uploaders-warcraftlogs/releases/download/${version}/${name}-${version}.AppImage";
        sha256 = "sha256:1fvy6q44jhyc82n1bki0dc9nmdlzkggjrgrr9h23v9rs8w7f7la7";
    };
    contents = pkgs.appimageTools.extract { inherit pname version src; };
in pkgs.appimageTools.wrapType2 {
    inherit pname name version src;
    extraInstallCommands = ''
        install -m 444 -D ${contents}/${name}.desktop $out/share/applications/${name}.desktop
        substituteInPlace $out/share/applications/${name}.desktop \
            --replace-fail 'Exec=AppRun' 'Exec=${pname}'
        cp -r ${contents}/usr/share/icons $out/share/icons
    '';
}
