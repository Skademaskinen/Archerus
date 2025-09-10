{ pkgs, archerusPkgs, ...}:

pkgs.stdenv.mkDerivation rec {
    pname = "webserver";
    version = "1.0.0";
    src = ./.;
    nativeBuildInputs = [ pkgs.cmake ];
    buildInputs = with pkgs; [
        httplib
        argparse
        openssl
        nlohmann_json
        cmake
        gcc
        archerusPkgs.libarcherus
    ];
    cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

    passthru.devShell = pkgs.mkShellNoCC {
        packages = buildInputs;
    };

    installPhase = ''
        mkdir -p $out/bin
        cp ${pname} $out/bin
    '';
}
