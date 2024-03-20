{lib, ...}: {
    imports = [
        ./nginx.nix
        ./nextcloud.nix
        ./jupyter.nix
    ];
}
