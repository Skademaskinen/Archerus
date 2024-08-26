{lib, ...}: {
    imports = [
        ./putricide.nix
        ./rp-utils.nix
        ./backend.nix
        ./taoshi-website.nix
        ./warcraftlogsuploader.nix
        ./python.nix
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
            default = "skade.dev";
        };
        test = lib.mkOption {
            type = lib.types.bool;
            default = false;
        };
    };

}
