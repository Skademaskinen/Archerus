{ self, lib, ... }:

let cfg = self.nixosConfigurations.Skademaskinen.config; in

lib.pkgs.writeScriptBin "testServer" ''
    #!${lib.pkgs.bash}/bin/bash
    rm -rf ${cfg.networking.hostName}.qcow2
    ${cfg.system.build.vm}/bin/run-${cfg.networking.hostName}-vm
''
