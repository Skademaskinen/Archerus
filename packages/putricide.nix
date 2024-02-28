{pkgs,}:{

}: let
    env = pkgs: with pkgs; [
        jdk21
        maven
    ];
in pkgs.stdenv.mkDerivation {
    name = "putricide";
    pname = "putricide";

    src = pkgs.fetchFromGitHub {
        owner = "Skademaskinen";
        repo = "Putricide";
        rev = "1d1ed002e1486a9cd6984edf99f8da04a7de2c32";
        sha256 = "sha256-ve40IH0VJWBE2QfZGaC6lYHkqB3KdeafslU99ojP4Wg=";
    };

    installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/usr/share/Putricide


        ${env.maven}/bin/mvn compile package -f ppbot
        ${env.maven}/bin/mvn clean -f ppbot
        mv *.jar ppbot.jar

        cp ./* $out/usr/share/Putricide -r
        echo "${env}/bin/java -jar $out/usr/share/Putricide/ppbot.jar \$@" > $out/bin/skademaskinen-putricide
    '';
}