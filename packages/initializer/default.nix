{ lib, nixpkgs, ...}:

let
    pkgs = lib.load nixpkgs;
in

pkgs.stdenv.mkDerivation rec {
    pname = "initializer";
    version = "1.0.0";
    src = ./.;
    nativeBuildInputs = [ pkgs.cmake ];
    buildInputs = with pkgs; [
        argparse
        cmake
        gcc
    ];
    cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

    passthru.devShell = pkgs.mkShellNoCC {
        packages = buildInputs;
    };

    preConfigure = lib.prepareCpplib;

    installPhase = ''
        mkdir -p $out/bin
        cp ${pname} $out/bin
    '';
}
