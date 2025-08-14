{ lib, ... }:

{
    mast3r = (lib.load ./default) "mast3r";
    taoshi = (lib.load ./default) "taoshi";
    default = lib.load ./default;
    work = lib.load ./work;
}
