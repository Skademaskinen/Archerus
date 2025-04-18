{pkgs, ...}:

"${pkgs.nwg-panel}/bin/nwg-panel -c ${./panel.json} -s ${./panel.css}"
