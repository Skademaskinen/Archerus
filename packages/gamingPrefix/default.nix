# This package will make sure that the gaming prefixes that i define are evaluated at compile time
# This means that something like 'lutris-prefix --wayland' will only be valid if wayland is enabled or something like that
# Essentially i'm packaging all my dependencies for gaming prefixes into a single binary
{ archerusPkgs, pkgs, ...}:


pkgs.stdenv.mkDerivation rec {
    pname = "gaming-prefix";
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

    passthru.devShell = pkgs.mkShellNoCC {
        packages = buildInputs;
    };

    installPhase = ''
        mkdir -p $out/bin
        cp steam-prefix lutris-prefix $out/bin
        ln $out/bin/steam-prefix $out/bin/gaming-prefix -s
    '';
}
