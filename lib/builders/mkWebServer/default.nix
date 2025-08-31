{ lib, nixpkgs, ...}:

let
    pkgs = lib.load nixpkgs;
in

config:

pkgs.stdenv.mkDerivation rec {
    pname = "nix-webserver";
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

    passthru.devShell = pkgs.mkShellNoCC {
        packages = buildInputs;
    };

    installPhase = ''
        mkdir -p $out/bin
        cp webserver $out/bin
        cp ${pkgs.writeScriptBin "nix-webserver" ''
            #!${pkgs.bash}/bin/bash
            exec PLACEHOLDER/bin/webserver --config ${pkgs.writeText "config.json" (builtins.toJSON config)} "$@"
        ''}/bin/nix-webserver $out/bin
        substituteInPlace $out/bin/nix-webserver --replace 'PLACEHOLDER' $out
    '';
}
