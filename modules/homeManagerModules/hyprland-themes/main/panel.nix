{ archerusPkgs, lib, ... }:

config:

let
    panel-json = lib.load ./panel.json.nix config;

    panel-css = builtins.readFile ./panel.css;
in

"${archerusPkgs.nwg.panel panel-json panel-css}"
