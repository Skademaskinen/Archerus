{ lib, self, system, ... }:

let
    homepage = self.packages.${system}.homepage;
    mkWebProject = lib.mkWebProject;
in

{ pkgs, lib, config, ... }:

{
    options.skade.projects.homepage = {
        port = lib.mkOption {
            type = lib.types.int;
            default = 8000;
        };
        db.name = lib.mkOption {
            type = lib.types.str;
            default = "homepage";
        };
        db.user = lib.mkOption {
            type = lib.types.str;
            default = "homepage";
        };
        db.host = lib.mkOption {
            type = lib.types.str;
            default = "localhost";
        };
        db.port = lib.mkOption {
            type = lib.types.int;
            default = 3306;
        };
        db.password = lib.mkOption {
            type = lib.types.str;
            default = "";
        };
        db.dialect = lib.mkOption {
            type = lib.types.str;
            default = "mysql";
        };
        loglevel = lib.mkOption {
            type = lib.types.str;
            default = "error";
        };
        interactive = lib.mkOption {
            type = lib.types.bool;
            default = false;
        };
        color = lib.mkOption {
            type = lib.types.bool;
            default = false;
        };
        editor.root = lib.mkOption {
            type = lib.types.str;
            default = "${config.skade.projectsRoot}/projects/homepage/editor";
        };
    };
    config = let 
        cfg = config.skade.projects.homepage;
    in mkWebProject config {
        name = "homepage";
        subdomain = "";
        port = cfg.port;
        stdinSocket = cfg.interactive;
        setup = ''
            ln -s ${homepage}/static $proot/static
            mkdir -p $proot/editor
            ${if cfg.db.dialect == "sqlite" then ''
                cd $proot
                export HOMEPAGE_DIALECT=sqlite
                ${homepage}/bin/homepage --migrate
            '' else ""}
        '';
        exec = "${homepage}/bin/homepage";
        environment = {
            HOMEPAGE_DB = cfg.db.name;
            HOMEPAGE_DB_USER = cfg.db.user;
            HOMEPAGE_DB_HOST = cfg.db.host;
            HOMEPAGE_DB_PORT = builtins.toString cfg.db.port;
            HOMEPAGE_DB_PASSWORD = cfg.db.password;
            HOMEPAGE_DIALECT = cfg.db.dialect;
            HOMEPAGE_PORT = builtins.toString cfg.port;
            HOMEPAGE_LOGLEVEL = cfg.loglevel;
            HOMEPAGE_INTERACTIVE = builtins.toString cfg.interactive;
            HOMEPAGE_COLOR = builtins.toString cfg.color;
            HOMEPAGE_EDITOR_ROOT = cfg.editor.root;
        };
    } // {
        environment.systemPackages = with pkgs; [
            (writeScriptBin "homepage-cli" ''
                #!${pkgs.bash}/bin/bash
                sudo -u homepage ${homepage}/bin/homepage --interactive
            '')
        ];
    };
}
