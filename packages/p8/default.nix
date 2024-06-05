{pkgs ? import <nixpkgs> {}, ...}: pkgs.stdenv.mkDerivation {
    name = "p8-backend";
    src = pkgs.fetchFromGitHub {
        owner = "cs-24-sw-8-11";
        repo = "Backend";
        rev = "master";
        sha256 = "sha256-WDidV2asbkRYvKaDEtwPWgmAzQ7Zp1Ex/AMy13ZrS80=";
        fetchSubmodules = true;
    };
    nativeBuildInputs = with pkgs; [
        cmake
    ];
}
