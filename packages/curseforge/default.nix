inputs:

let 
    pkgs = import inputs.nixpkgs { system = inputs.system; }; 
    name = "curseforge";
    pname = "CurseForge";
    version = "1.283.2-27468";
    rawPath = "${inputs.curseforge}";
    src = "${rawPath}/${pname}-${version}.AppImage";
    contents = pkgs.appimageTools.extract { inherit pname version src; };
in

pkgs.appimageTools.wrapType2 {
    inherit pname name version src;
    extraInstallCommands = ''
        install -m 444 -D ${contents}/${name}.desktop $out/share/applications/${name}.desktop
        substituteInPlace $out/share/applications/${name}.desktop \
            --replace-fail 'Exec=AppRun' 'Exec=${pname}'
        cp -r ${contents}/usr/share/icons $out/share/icons
    '';
}
