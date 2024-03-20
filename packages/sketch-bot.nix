{pkgs ? import <nixpkgs> {}, ...}: let
    name = "SketchBot";
in pkgs.stdenv.mkDerivation {
    name = name;
    pname = name;
    src = pkgs.fetchFromGitHub {
        owner = "Taoshix";
        repo = name;
        rev = "ec25283f78ee91b7ee787119f9c0aca0b1f8dd3a";
        sha256 = "sha256-mqkruofitvf2qXrd/tSUBYQaNbrZ+QokyN9iVmzUFGY=";
    };
    installPhase = ''
        mkdir -p $out/share/SketchBot
        mkdir -p $out/bin
        cp -r $src/* $out/share/SketchBot
        cat > $out/bin/sketch-bot << EOF
            #!${pkgs.bash}/bin/bash
            ${pkgs.dotnet-sdk_8}/bin/dotnet run --project $out/share/SketchBot/SketchBot \$@
        EOF
        chmod +x $out/bin/sketch-bot
    '';
}