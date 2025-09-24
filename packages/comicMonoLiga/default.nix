{ pkgs, nixpkgs, lib, ...}:

pkgs.comic-mono.overrideAttrs {
    src = pkgs.fetchFromGitHub {
        owner = "wayou";
        repo = "comic-mono-font";
        rev = "2961b5d7c8ec497f6e8e50c5b9cb136af49de325";
        sha256 = "sha256-Zv3jMDidwbzFbY7rkJ5DnaHsNPYQsN2znSVTB0kQ6Y0=";
    };
}
