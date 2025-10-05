{ pkgs, ... }: css:

pkgs.writeShellScript "nwg-drawer.sh" ''
    #!${pkgs.bash}/bin/bash
    ${pkgs.nwg-drawer}/bin/nwg-drawer -s ${pkgs.writeText "drawer.css" css} "$@"
''
