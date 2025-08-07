{ lib, ... }:

lib.mkSubmodules [
    ./mast3r.nix
    ./taoshi.nix
]
