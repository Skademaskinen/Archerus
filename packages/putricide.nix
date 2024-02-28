{pkgs,}: pkgs.maven.buildMavenPackage {
    name = "putricide";
    pname = "putricide";
    version = "3.38a";

    src = pkgs.fetchFromGitHub {
        owner = "Skademaskinen";
        repo = "Putricide";
        rev = "dc7422c874d513326ee963796ad38c2ea8b15455";
        sha256 = "sha256-gQWY8+66V3jxUXWtVlkRzv59k/LwKkRKZ56dTSV0U1Q=";
    };
    installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/usr/share/Putricide

        mv *.jar ppbot.jar

        cp ./* $out/usr/share/Putricide -r
        echo "${pkgs.jdk21}/bin/java -jar $out/usr/share/Putricide/ppbot.jar \$@" > $out/bin/skademaskinen-putricide
    '';
}