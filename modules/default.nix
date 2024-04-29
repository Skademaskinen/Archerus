{lib, ...}: {
    imports = [
        ./minecraft.nix
        ./putricide.nix
        ./rp-utils.nix
        ./mast3r-website.nix
        ./warcraftlogsuploader.nix
        ./python.nix
        ./taoshi-website.nix
        ./sketch-bot.nix
        ./matrix.nix
    ];
    options.skademaskinen = {
        storage = lib.mkOption {
            type = lib.types.str;
            default = "/";
        };
        domain = lib.mkOption {
            type = lib.types.str;
            default = "localhost";
        };
        test = lib.mkOption {
            type = lib.types.bool;
            default = false;
        };
    };

}
