{
    pkgs ? import <nixpkgs> {},
}: {

    pkgs.stdenv.mkDerivation = {
        name = "backend";
        pname = "backend";

        src = fetchGit {
            url = "https://github.com/Skademaskinen/Backend.git";
            name = "src";
        };
        
    installPhase = "echo 'test' > /tmp/test";
    };
}
