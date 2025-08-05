{ lib, ... }:

{
    imports = [
        (lib.iCall ./options)
        (lib.iCall ./config)
    ];
}
