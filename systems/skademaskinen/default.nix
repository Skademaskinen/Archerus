{pkgs, lib, config, modulesPath, ...}: let
    storage = "/mnt/raid";
    version = "23.11";
    tools = import ../../tools;
in {
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix") 
        ./packages.nix
        ./modules
    ];

    # hardware
    boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];
    boot.swraid.enable = true;
    boot.swraid.mdadmConf = "MAILADDR mast3r@${config.skademaskinen.domain}";

    fileSystems = {
        "/" = { 
            device = "/dev/disk/by-label/ROOT";
            fsType = "ext4";
        };
        "/boot" = {
            device = "/dev/disk/by-label/BOOT";
            fsType = "vfat";
        };
        "${storage}" = {
            device = "/dev/disk/by-label/STORAGE";
            fsType = "ext4";
        };
    };
    swapDevices = [{ device="/dev/disk/by-uuid/3aac8229-8ab1-4c0d-a2c6-d27859553817"; }];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    system.stateVersion = version;

    # security
    security.sudo.wheelNeedsPassword = false;

    nix.settings.allowed-users = ["root" "@wheel"];
    nix.settings.trusted-users = ["root" "@wheel"];

    networking.hostName = "Skademaskinen";

    # virtualisation specifics `nixos-rebuild build-vm --flake .#Skademaskinen`
    virtualisation.vmVariant = {
        virtualisation.memorySize = 8192;
        virtualisation.cores = 4;
        skademaskinen.domain = "localhost";

        users.users.root.password = "1234";
        users.users.root.packages = [pkgs.nmap];
        services.getty.autologinUser = "root";
        virtualisation.forwardPorts = builtins.concatLists [
            [{ from = "host"; host.port = 2222; guest.port = 22; }]
            (map (server: {
                from = "host";
                host.port = server.server-port;
                guest.port = server.server-port;
            }) (builtins.attrValues config.skademaskinen.minecraft.servers))
            (if (tools.attrLength config.skademaskinen.minecraft.servers) > 0 then 
                [{ from = "host"; host.port = 25565; guest.port = 25565; }]
            else
                [])
        ];
        virtualisation.graphics = false;
        environment.etc."nextcloud-admin-password".text = "1234";
    };

    users.mutableUsers = false;

    # VPN CONFIG
    #services.openvpn.servers.VPN.config = "config ${storage}/VPN/windscribe.conf";

    networking.wireguard.interfaces = {
        wg0 = {
            ips = ["10.200.200.2/32"];
            listenPort = 51820;
            privateKeyFile = "${storage}/vpn/client.key";
            peers = [{
                publicKey = "fOPhWd+No02Doi2hvf3uXmAHYF+nyeOcmEBFWkzBRAk=";
                allowedIPs = ["10.200.200.0/24"];
                endpoint = "185.51.76.92:51820";
                persistentKeepalive = 25;
            }];
        };
    };

    services.mysql.enable = true;
    services.mysql.dataDir = "/mnt/raid/mysql";
    services.mysql.package = pkgs.mysql;

    # custom module settings
    skademaskinen = {
        storage = storage;
        putricide = {
            enable = true;
            config = "${storage}/bots/Putricide";
            args = [ "--disable-teams" ];
        };
        minecraft.servers = {
            hub = {
                server-port = 25566;
                force-gamemode = true;
                gamemode = "adventure";
                white-list = false;
                enforce-whitelist = false;
                online-mode = false;
                difficulty = "peaceful";
            };
            survival = {
                server-port = 25567;
                white-list = true;
                enforce-whitelist = true;
                online-mode = false;
                difficulty = "hard";
                bukkit.settings.allow-end = false;
            };
            creative = {
                server-port = 25568;
                white-list = true;
                enforce-whitelist = true;
                online-mode = false;
                difficulty = "hard";
            };
            paradox = {
                server-port = 25569;
                white-list = true;
                enforce-whitelist = true;
                online-mode = false;
                difficulty = "hard";
            };
        };
        minecraft.fallback = "hub";
        minecraft.motd = "<#ff5500>Skademaskinen Declarative <rainbow>Minecraft <#ff5500>server";
        minecraft.icon = ../../files/icon.png;

        rp-utils = {
            enable = true;
            root = "${storage}/bots/rp-utils";
        };

        mast3r.website = {
            enable = true;
            root = "${storage}/website/Backend";
            databasePath = "${storage}/website/db.db3";
            hostname = "localhost";
            port = 8000;
            keyfile = "${storage}/website/keyfile";
        };
        taoshi.website = {
            enable = true;
            port = 8004;
        };
        sketch-bot = {
            enable = true;
            root = "${config.users.users.taoshi.home}/SketchBot/SketchBot";
        };
        jupyter.port = 8002;
        nextcloud.port = 8003;

        matrix.enable = true;
        matrix.port = 8005;

    };
    globalEnvs.python.enable = true;
}
