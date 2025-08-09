{ gradle2nix, lib, nixpkgs, ... }:

let
    pkgs = lib.load nixpkgs;
    name = "Folkevognen";
    version = "1.0";
    pname = name;
    owner = "Skademaskinen";
    repo = name;
    rev = "master";
    sha256 = "sha256-xEHnatW73ajBoa9fI+WgRSHiZ1JbN8O6F6KgNehNocU=";
    src = pkgs.fetchFromGitHub { inherit owner repo rev sha256; };
in

gradle2nix.builders.x86_64-linux.buildGradlePackage rec {
    inherit name version pname src;
    lockFile = ./gradle.lock;
    gradleBuildFlags = ["build -x test"];
    gradleInstallFlags = ["installDist -x test"];

    installPhase = ''
        mkdir -p $out/{lib,share}/${name}
        mkdir $out/bin
        cp ./app/build/libs/app-all.jar $out/lib/${name}/${name}.jar
        cp -r $src/* $out/share/${name}
        substitute ${pkgs.writeText name ''
            #!${pkgs.bash}/bin/bash
            set -e
            ${pkgs.jdk21}/bin/java --enable-preview -jar REPLACE_ME/lib/${name}/${name}.jar $@
        ''} $out/bin/${name} --replace-fail REPLACE_ME $out
        chmod +x $out/bin/${name}
    '';
}
