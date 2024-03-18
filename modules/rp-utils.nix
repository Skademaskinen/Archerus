{lib, pkgs, config, ...}:{

    options.skademaskinen.rp-utils = {
        enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
        };
        root = lib.mkOption {
            type = lib.types.str;
        };
        
    };
    config = {
        systemd.services.rp-utils = {
            enable = config.skademaskinen.rp-utils.enable;
            description = "rp-utils bot";
            environment = {
                XELATEX_PATH = "${pkgs.texliveFull}/bin/xelatex";
                BASH_PATH = "${pkgs.bash}/bin/bash";
                SQLITE3_PATH = "${pkgs.sqlite}/bin/sqlite3";
                PYTHON_EXE_PATH = "${pkgs.python3}/bin/python";
            };
            serviceConfig = {
                WorkingDirectory = config.skademaskinen.rp-utils.root;
                User = "mast3r";
                ExecStart = "${pkgs.gradle}/bin/gradle run -Dorg.gradle.java.home=${pkgs.jdk21}/lib/openjdk";
            };
            wantedBy = ["default.target"];
            after = ["network-online.target"];
            wants = ["network-online.target"];
        };
    };
}
