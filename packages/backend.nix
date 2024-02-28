{
    pkgs,
}: let
    py = (pkgs.python3.withPackages (pyPkgs: with pyPkgs; [
        requests
        python-nmap
        bcrypt
    ]));

in pkgs.stdenv.mkDerivation {
        name = "backend";
        pname = "backend";

        src = pkgs.fetchFromGitHub {
            owner = "Skademaskinen";
            repo = "Backend";
            rev = "9444f35173129916a0dd227c2184ffc69bb8f6bb";
            sha256 = "sha256-QeCqdSIImMFe21o6t4Xhc4PxMhNc1TzukTvugy9c0Kk=";

        };

        installPhase = ''
            mkdir -p $out/bin
            mkdir -p $out/usr/share/Backend
            
            cp ./* $out/usr/share/Backend -r
            echo "${py.interpreter} $out/usr/share/Backend/skademaskinen/Backend.py \$@" > $out/bin/skademaskinen-backend
            chmod +x $out/bin/skademaskinen-backend
        '';
        
}
