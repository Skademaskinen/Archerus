{
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        ../users/mast3r
        ../users/taoshi

        ../services/jupyter.nix
        ../services/lavalink.nix
        ../services/minecraft.nix
        ../services/mysql.nix
        ../services/nextcloud.nix
        ../services/nginx.nix
        ../services/Putricide.nix
        ../services/SketchBot.nix
        ../services/ssh.nix
        ../services/vpn.nix
        ../services/website.nix
        ../services/wordcount.nix

        ../setup/systemd-boot.nix
        ../setup/locale.nix
        ../setup/networking.nix
        ../setup/packages.nix
        ../setup/security.nix
    ];

    boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];

    fileSystems."/" ={ 
        device = "/dev/disk/by-uuid/5a5f7fe7-d227-4ee4-a55c-f7b8582a2c3d";
        fsType = "ext4";
    };

    fileSystems."/boot" = { 
        device = "/dev/disk/by-uuid/444A-C8A5";
        fsType = "vfat";
    };
    fileSystems."/mnt/raid" = { 
        device = "/dev/disk/by-uuid/92eb9f28-f56d-4753-9474-b2e79de753a8";
        fsType = "ext4";
    };

    swapDevices = [{ 
        device = "/dev/disk/by-uuid/3aac8229-8ab1-4c0d-a2c6-d27859553817"; 
    }];


    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
