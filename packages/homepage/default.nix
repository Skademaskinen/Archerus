inputs:

let
    pkgs = inputs.lib.pkgs;
    pname = "homepage";
    version = "0.1.0.0";
    owner = "Skademaskinen";
    repo = pname;
    rev = "master";
    sha256 = "sha256-dsU2gWdqiCQPizTkm5S1OSMio+kq/PNc1OKRjq3Pk74=";
    src = pkgs.fetchFromGitHub { inherit owner repo rev sha256; };
    env = pkgs.python312.withPackages (py: with py; [ matplotlib scipy ]);
    dependencies = with pkgs.haskellPackages; [
        aeson base blaze-builder blaze-html bytestring
        cryptonite directory http-conduit http-types ihp-hsx 
        monad-logger password persistent persistent-mysql regex-compat 
        split string-random text time utf8-string 
        uuid wai warp yaml raw-strings-qq 
        persistent-sqlite matplotlib aeson-qq persistent-postgresql
        rawstring-qm

    ];
    homepage = pkgs.haskellPackages.mkDerivation {
        inherit pname version src;
        isLibrary = false;
        isExecutable = true;
        libraryHaskellDepends = dependencies;
        executableHaskellDepends = dependencies ++ [ env ];
        testHaskellDepends = with pkgs.haskellPackages; [ base ];
        postInstall = ''
            cp -r $src/static $out
        '';
        doHaddock = false;
        license = "unknown";
    };
in

homepage
