{lib, ...}: {
    networking = {
        hostName = "Skademaskinen";
        networkmanager = {
            enable = true;
        };
        useDHCP = lib.mkDefault true;
        firewall = {
            allowedTCPPorts = [ 22 30000 25565 8080 443 80 3389 40000 ];
        };
    };
}