{ lib, ... }:

lib.mkSubmodules [
    ./base.nix
    ./projects/homepage.nix
    ./projects/palworld.nix
    ./projects/putricide.nix
    ./projects/folkevognen.nix
    ./projects/dummyProject.nix
]
