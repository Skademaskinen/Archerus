{pkgs,}:let
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
        rev = "03e68258c68be275d92e06fa4bf64aef6d199811";
        sha256 = "sha256-zTMenCngej0XHEqnMFtDITn63w9pOaVLbQtNFXGu3m0=";
    };

    installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/share/Backend
        
        cp ./* $out/share/Backend -r
        echo "${py.interpreter} $out/share/Backend/skademaskinen/Backend.py \$@" > $out/bin/skademaskinen-backend
        chmod +x $out/bin/skademaskinen-backend

        cat > $out/bin/skademaskinen-backend-db << "EOF"
            if [[ "$1" == "" ]]; then
                db="/tmp/db.db3"
            else
                db="$1"
            fi
            for table in $(${pkgs.sqlite-interactive}/bin/sqlite3 $db '.tables'); do
                echo "Content of table: $table"
                ${pkgs.sqlite-interactive}/bin/sqlite3 $db "select * from $table" -box
            done
        EOF
        chmod +x $out/bin/skademaskinen-backend-db
    '';
        
}
