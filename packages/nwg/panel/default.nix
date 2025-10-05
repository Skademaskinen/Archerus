{ pkgs, ... }: config: css:

pkgs.writeShellScript "nwg-panel.sh" ''
    #!${pkgs.bash}/bin/bash
    ${pkgs.nwg-panel}/bin/nwg-panel -c ${pkgs.writeText "panel.json" (builtins.toJSON config)} -s ${pkgs.writeText "panel.css" css} "$@"
''
