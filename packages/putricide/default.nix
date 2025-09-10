{ pkgs, ... }:

let
    name = "Putricide";
    pname = "ppbot";
    version = "3.38a";
    owner = "Skademaskinen";
    repo = name;
    rev = "master";
    sha256 = "sha256-xkKelk7tJdh06R744tkWU7jfwUaNaXo2Io+uqpf/Pls=";
    src = pkgs.fetchFromGitHub { inherit owner repo rev sha256; };

in

pkgs.maven.buildMavenPackage {
    inherit name pname version src;

    mvnParameters = "-f ${pname}";
    mvnHash = "sha256-cuJvC/yYEC9ok2991y0VjGhycNBnaDOPv1SxZj6lrjA=";

    installPhase = ''
        mkdir -p $out/{lib,share}/${name}
        mkdir $out/bin
        cp ${pname}-${version}.jar $out/lib/${name}/${name}.jar
        cp -r $src/* $out/share/${name}
        substitute ${pkgs.writeText pname ''
            #!${pkgs.bash}/bin/bash
            set -e
            ${pkgs.jdk21}/bin/java -jar REPLACE_ME/lib/${name}/${name}.jar $@
        ''} $out/bin/${pname} --replace-fail REPLACE_ME $out
        chmod +x $out/bin/${pname}
    '';
}
