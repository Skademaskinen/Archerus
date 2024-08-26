{pkgs, lib, config, ...}: 
let
    cfg = config.skademaskinen.mast3r.website;
    website-flake = import "${pkgs.fetchFromGitHub {
        owner = "Mast3rwaf1z"; 
        repo = "homepage"; 
        rev = "master"; 
        sha256 = "sha256-Ci8mNtP0k9hgZJOk0AM8GpKFqNDp34nTWiunV3Lt+GU=";
    }}/default.nix";
in {
    options.skademaskinen.mast3r.website = {
        enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
        };
        port = lib.mkOption {
            type = lib.types.int;
            default = 12345;
        };
        dbPath = lib.mkOption {
            type = lib.types.str;
            default = "/var/db/homepage.db3";
        };
    };

    config.systemd.services.website = {
        enable = cfg.enable;
        environment.HOMEPAGE_DB = cfg.dbPath;
        environment.HOMEPAGE_PORT = builtins.toString cfg.port;
        serviceConfig = {
            WorkingDirectory = "${website-flake.outputs.packages.x86_64-linux.default}";
            ExecStart = "${website-flake.outputs.packages.x86_64-linux.default}/bin/homepage";
        };
        wantedBy = ["default.target"];
    };
}