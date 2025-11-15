{ archerusPkgs, pkgs, packages?(builtins.attrNames pkgs), ...}:

pkgs.stdenv.mkDerivation rec {
    pname = "nix-launcher";
    version = "1.0.0";
    src = ./.;
    nativeBuildInputs = [ pkgs.cmake pkgs.qt6.wrapQtAppsHook ];
    buildInputs = with pkgs; [
        argparse
        cmake
        gcc
        nlohmann_json
        qt6Packages.qtbase
        archerusPkgs.libarcherus
    ];
    cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

    passthru = {
        devShell = pkgs.mkShellNoCC {
            packages = buildInputs;
        };
        withPackages = packages: import ./default.nix { inherit archerusPkgs pkgs packages; };
    };



    installPhase = ''
        mkdir -p $out/{etc/archerus,bin}
        cp ${pname} $out/bin
        cat ${pkgs.writeText "packages.json" (builtins.toJSON packages)} > $out/etc/archerus/${pname}.json
    '';
}
