{lib, ...}: {
    imports = [
        ./nginx.nix
        ./nextcloud.nix
        ./jupyter.nix
        ./minecraft.nix
        ./website.nix
    ];
}
