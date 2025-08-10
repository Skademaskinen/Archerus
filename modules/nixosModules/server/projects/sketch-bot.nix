{ lib, self, system, ...}:

let
    mkProject = lib.mkProject;
    sketch-bot = self.packages.${system}.sketch-bot;
    lavalink = self.packages.${system}.lavalink;
    name = "SketchBot";
in

{ config, lib, ... }: 

{
    options.skade.projects.sketch-bot = {
        root = lib.mkOption {
            type = lib.types.str;
            default = "${config.skade.projectsRoot}/projects/sketch-bot";
        };
    };
    imports = [
        (mkProject config {
            name = "lavalink";
            exec = "${lavalink}/bin/lavalink";
        })
    ];
    config = mkProject config {
        inherit name;
        exec = "${sketch-bot}/bin/${name}";
        setup = ''
            cp -rf ${sketch-bot}/lib/* $proot
        '';
    };
}
