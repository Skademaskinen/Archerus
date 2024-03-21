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
        rev = "1b152e2c083ec2e53d81a5c5904e0c263c8cb85d";
        sha256 = "sha256-7KFlz4V7fqKqMBJ0OyESCuAyZVMY7WH1N6uMzMs82V4=";
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
