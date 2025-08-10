{ self, nixpkgs, lib, ... }:

let
    
    cfg = self.nixosConfigurations.Skademaskinen.config;
    pkgs = lib.load nixpkgs;
in

pkgs.writeScriptBin "testServer" ''
    #!${pkgs.bash}/bin/bash
    rm -rf ${cfg.networking.hostName}.qcow2
    ${cfg.system.build.vm}/bin/run-${cfg.networking.hostName}-vm
''
