{pkgs}:let
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
        rev = "f507c7de0957035c51a6c2fe631c5980df7c6b3d";
        sha256 = "sha256-LjUZN60tuzsSJ/WOY1v2bdUFpQX2DMG6K2vyJNBXHE4=";
    };

    installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/share/Backend
        
        cp ./* $out/share/Backend -r
        echo "${py.interpreter} $out/share/Backend/skademaskinen/main.py \$@" > $out/bin/skademaskinen-backend
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
