# This package will make sure that the gaming prefixes that i define are evaluated at compile time
# This means that something like 'lutris-prefix --wayland' will only be valid if wayland is enabled or something like that
# Essentially i'm packaging all my dependencies for gaming prefixes into a single binary
{ archerusPkgs, pkgs, config?{ config = []; icon = ""; }, ...}:



pkgs.stdenv.mkDerivation rec {
    pname = "pfx";
    version = "1.0.0";
    src = ./.;
    nativeBuildInputs = [ pkgs.cmake ];
    buildInputs = with pkgs; [
        argparse
        cmake
        gcc
        nlohmann_json
        libnotify
        glib
        pkg-config
        archerusPkgs.libarcherus
    ];
    cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

    passthru = {
        devShell = pkgs.mkShellNoCC {
            packages = buildInputs;
        };
        withConfig = config: import ./default.nix { inherit archerusPkgs pkgs config; };
    };



    installPhase = ''
        mkdir -p $out/{etc/archerus,bin}
        cp pfx $out/bin
        echo '${builtins.toJSON config.config}' > $out/etc/archerus/config.json
        ${if config.icon != "" then ''
            cp ${config.icon} $out/etc/archerus/config.png
        '' else ""}
    '';
}
