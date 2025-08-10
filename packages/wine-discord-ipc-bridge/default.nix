{ nixpkgs, lib, ... }: 

let 
    pkgs = lib.load nixpkgs;
in 

pkgs.callPackage ({ pkgs, lib, stdenv, wine, pkgsCross, ... }: let

    src = pkgs.fetchFromGitHub { owner = "0e4ef622"; repo = "wine-discord-ipc-bridge"; rev = "v0.0.3"; sha256 = "sha256-jzsbOKMakNQ6RNMlioX088fGzFBDxOP45Atlsfm2RKg="; };
    version = "0.0.3";

in stdenv.mkDerivation {
    pname = "wine-discord-ipc-bridge";
    inherit version src;

    nativeBuildInputs = [pkgsCross.mingw32.stdenv.cc wine];

    installPhase = ''
        mkdir -p $out/bin
        cp winediscordipcbridge.exe $out/bin
        cp winediscordipcbridge-steam.sh $out/bin
    '';

    meta = {
        description = "Enable games running under wine to use Discord Rich Presence";
        homepage = "https://github.com/0e4ef622/wine-discord-ipc-bridge";
        license = lib.licenses.mit;
        maintainers = with lib.maintainers; [fufexan];
        platforms = ["x86_64-linux"];
    };
}) {}
