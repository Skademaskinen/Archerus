{ archerusPkgs, ... }:

let
    drawer-css = builtins.readFile ./drawer.css;
in

"${archerusPkgs.nwg.drawer drawer-css}"
