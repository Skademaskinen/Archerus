{lib, ...}: {
    imports = [
        ./nginx.nix
        ./nextcloud.nix
        ./jupyter.nix
        ./F3.nix
    ];
}
