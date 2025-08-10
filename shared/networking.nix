{lib, ...}: {
    networking = {
        networkmanager = {
            enable = true;
        };
        useDHCP = lib.mkDefault true;
        firewall = {
            allowedTCPPorts = [ 22 30000 25565 8080 443 80 3389 40000 ];
        };
    };

    services.openssh = {
        enable = true;
        settings.PermitRootLogin = "yes";
        settings.X11Forwarding = true;
        settings.PasswordAuthentication = false; 
    };
}
