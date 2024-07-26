{config, pkgs, lib, ...}: let
    cfg = config.skademaskinen.F3;

    frontend = pkgs.stdenv.mkDerivation rec {
        name = "F3";
        
        src = pkgs.fetchFromGitHub {
            owner = "Skademaskinen";
            repo = name;
            rev = "master";
            sha256 = "sha256-gXPS6uNL9v17DOLjFhHPsgqqN41xzr7KNyblBMxQVUc=";
        };
    };
in {
    options.skademaskinen.F3.port = lib.mkOption {
        type = lib.types.int;
        default = 8008;
    };
    config.systemd.services.F3 = {
        enable = true;
        environment = {
            SKADEMASKINEN_FRONTEND_PORT = builtins.toString cfg.port;
        };
        serviceConfig = {
            ExecStart = "${config.skademaskinen.storage}/website/F3/result/bin/RunProdServer"; 
        };
        wantedBy = ["default.target"];
    };
}
