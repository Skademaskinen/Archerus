{lib, config, modulesPath, ...}: let
    storage = "/mnt/raid";
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

    system.stateVersion = "23.11";

    # security
    security.sudo.wheelNeedsPassword = false;

    nix.settings.allowed-users = ["root" "@wheel"];
    nix.settings.trusted-users = ["root" "@wheel"];

    networking.hostName = "Skademaskinen";

    # virtualisation specifics `nixos-rebuild build-vm --flake .#Skademaskinen`
    virtualisation.vmVariant = {
        virtualisation.memorySize = 8192;
        virtualisation.cores = 4;

        users.users.root.password = "1234";
        services.getty.autologinUser = "root";
        virtualisation.forwardPorts = [
            { from = "host"; host.port = 2222; guest.port = 22; }
            { from = "host"; host.port = 8888; guest.port = 80; }
            { from = "host"; host.port = 4443; guest.port = 443; }
        ];
        environment.etc."nextcloud-admin-password".text = "1234";
    };

    users.mutableUsers = false;

    # VPN CONFIG
    services.openvpn.servers.VPN.config = "config ${storage}/VPN/windscribe.conf";

    # custom module settings
    skademaskinen = {
        storage = storage;
        domain = "localhost"; # change to localhost on tests
        putricide = {
            enable = true;
            config = "${storage}/bots/Putricide";
            args = [ "--disable-teams" ];
        };
        minecraft-servers = ["survival" "hub" "creative" "paradox"];

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
            port = 8001;
        };
        sketch-bot = {
            enable = true;
            root = "${config.users.users.taoshi.home}/SketchBot/SketchBot";
        };
        jupyter.port = 8002;
        nextcloud.port = 8003;
    };
}
