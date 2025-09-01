{ lib, nixpkgs, ...}:

let
    pkgs = lib.load nixpkgs;
in

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
    ];
    cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

    preConfigure = lib.prepareCpplib;

    passthru.devShell = pkgs.mkShellNoCC {
        packages = buildInputs;
    };

    installPhase = ''
        mkdir -p $out/bin
        cp ${pname} $out/bin
    '';
}
