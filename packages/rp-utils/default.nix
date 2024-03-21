{pkgs,}: pkgs.stdenv.mkDerivation {
    pname = "rp-utils";
    name = "rp-utils";

    src = pkgs.fetchFromGitHub {
        owner = "Skademaskinen";
        repo = "rp-utils";
        rev = "81524107cb729a14c35dcbffd5632138c5ce00f8";
        sha256 = "sha256-Eszh8sHRg3w+N329EFbKV1ryYo/qpcWEcj4WpK4MXps=";
    };

    nativeBuildInputs = [
        pkgs.gradle
    ];

    buildPhase = ''
        gradle --offline shadowJar
    '';

    installPhase = ''
        cp app/build/libs/app-all.jar ./rp-utils.jar

        mkdir $out/share/rp-utils
        cp /* $out/share/rp-utils -r

        echo "${pkgs.jdk21}/bin/java -jar $out/share/rp-utils.jar \$@" > $out/bin/skademaskinen-rp-utils
        chmod +x $out/bin/skademaskinen-rp-utils
    '';
}