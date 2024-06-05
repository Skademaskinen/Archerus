{pkgs, ...}: let
    print = pkgs.writeScriptBin "print-aau" ''
        echo -n Password: 
        read -s password
        ${pkgs.samba}/bin/smbspool "smb://$1:$password@STUDENT/mfc-print03.aau.dk/Follow-You" 0 $1 printscript 1 "" "$2"
    '';
in {
    environment.systemPackages = with pkgs; [
        discord
        vscode
        yakuake
        direnv
        kmail
        spotify
        obs-studio
        print
        comic-mono
        thunderbird
        protonmail-bridge
        pass
    ];
    nixpkgs.config.allowUnfree = true;
    programs.firefox.enable = true;

    nix.settings.trusted-users = [ "root" "mast3r" ];
    services.cachix-agent.enable = true;
}
