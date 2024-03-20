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

    fileSystems = {
        "/" = { 
            device = "/dev/disk/by-uuid/5a5f7fe7-d227-4ee4-a55c-f7b8582a2c3d";
            fsType = "ext4";
        };
        "/boot" = {
            device = "/dev/disk/by-uuid/444A-C8A5";
            fsType = "vfat";
        };
        "${storage}" = {
            device = "/dev/disk/by-uuid/92eb9f28-f56d-4753-9474-b2e79de753a8";
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
        ];
    };

    users.mutableUsers = false;

    # custom module settings
    skademaskinen = {
        storage = storage;
        domain = "localhost";
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

        website = {
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
        jupyter.port = 8002;
        nextcloud.port = 8003;
    };
}
