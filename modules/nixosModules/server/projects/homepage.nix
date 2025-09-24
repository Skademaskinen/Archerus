{ lib, archerusPkgs, self, system, ... }:

let
    homepage = archerusPkgs.homepage;
    mkWebProject = lib.mkWebProject;
in

{ pkgs, lib, config, ... }:

{
    options.skade.projects.homepage = {
        port = lib.mkOption {
            type = lib.types.int;
            default = 8000;
            description = ''
                Port to host the server on
            '';
        };
        db.name = lib.mkOption {
            type = lib.types.str;
            default = "homepage";
            description = ''
                name of the database, path if sqlite
            '';
        };
        db.user = lib.mkOption {
            type = lib.types.str;
            default = "homepage";
            description = ''
                Database user, not relevant for sqlite
            '';
        };
        db.host = lib.mkOption {
            type = lib.types.str;
            default = "localhost";
            description = ''
                host or ip of sql server, not relevant for sqlite
            '';
        };
        db.port = lib.mkOption {
            type = lib.types.int;
            default = 3306;
            description = ''
                port of db, not relevant for sqlite
            '';
        };
        db.password = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = ''
                password for the database, not relevant for sqlite
            '';
        };
        db.dialect = lib.mkOption {
            type = lib.types.str;
            default = "mysql";
            description = ''
                The sqlite dialect, only sqlite, mysql and postgres is supported
            '';
        };
        loglevel = lib.mkOption {
            type = lib.types.str;
            default = "error";
            description = ''
                Log level of the server
            '';
        };
        interactive = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
                whether to take commands from stdin
            '';
        };
        color = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
                Print output in color, disabled by default for systemd compatibility
            '';
        };
        editor.root = lib.mkOption {
            type = lib.types.str;
            default = "${config.skade.projectsRoot}/projects/homepage/editor";
            description = ''
                text editor project's root for saving files.
            '';
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
