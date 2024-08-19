{config, pkgs, lib, ...}: let
    cfg = config.skademaskinen.F3;

    frontend = import "${(pkgs.fetchFromGitHub {
        owner = "skademaskinen";
        repo = "F3";
        rev = "master";
        sha256 = "sha256-Y0bvdhlALkpI+JvmLIT4dnAsMOQDVYF3uUgnCq0ebpA=";
    })}/default.nix";
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
            ExecStart = "${frontend.outputs.packages.x86_64-linux.default}/bin/RunProdServer"; 
        };
        wantedBy = ["default.target"];
    };
}
