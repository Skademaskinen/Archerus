{ lib, ... }:

{
    mast3r = (lib.iCall ./mast3r.nix);
    taoshi = (lib.iCall ./taoshi.nix);
}
