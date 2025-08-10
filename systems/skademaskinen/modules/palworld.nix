{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        xdg-user-dirs
    ];
    networking.firewall.allowedUDPPorts = [ 8211 ];
    systemd.services.palworld = {
        enable = true;
        path = with pkgs; [
            xdg-user-dirs
        ];
        serviceConfig = {
            User = "mast3r";
            ExecStart = "/mnt/raid/palworld/PalServer.sh";
            StandardError="journal";
            WorkingDirectory = "/mnt/raid/palworld";
            Restart = "on-failure";
        };
    };

    programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
            
        ];
    };
}
