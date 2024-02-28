{pkgs,}: pkgs.maven.buildMavenPackage {
    name = "putricide";
    pname = "putricide";
    version = "3.38a";

    mvnParameters = "-f ppbot";
    mvnHash = "sha256-cuJvC/yYEC9ok2991y0VjGhycNBnaDOPv1SxZj6lrjA=";

    src = pkgs.fetchFromGitHub {
        owner = "Skademaskinen";
        repo = "Putricide";
        rev = "15240e905e17173990c9057432a8532879244cb3";
        sha256 = "sha256-InYSJlR4Q84vZdXV1oFnDlMR3vQNevuRrxSYW5jqtLI=";
    };
    installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/usr/share/Putricide

        mv *.jar ppbot.jar

        cp ./* $out/usr/share/Putricide -r
        echo "${pkgs.jdk21}/bin/java -jar $out/usr/share/Putricide/ppbot.jar \$@" > $out/bin/skademaskinen-putricide
        chmod +x $out/bin/skademaskinen-putricide
    '';
}