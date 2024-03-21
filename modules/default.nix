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
    };

}
