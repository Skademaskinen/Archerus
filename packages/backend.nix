{
    pkgs ? import <nixpkgs> {},
    fetchGit ? pkgs.fetchGit
}: {

    pkgs.stdenv.mkDerivation = {
        name = "backend";
        pname = "backend";

        src = fetchGit {
            url = "https://github.com/Skademaskinen/Backend.git";
            name = "src";
        
        installPhase = "";
        };
    };
}
