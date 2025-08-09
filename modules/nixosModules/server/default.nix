{ lib, ... }:

lib.mkSubmodules [
    ./base.nix
    ./projects/homepage.nix
    ./projects/putricide.nix
    ./projects/folkevognen.nix
    ./projects/dummyProject.nix

    # external projects
    ./projects/palworld.nix
    ./projects/mysql.nix
    ./projects/postgres.nix
    ./projects/minecraft.nix
    ./projects/matrix.nix
]
