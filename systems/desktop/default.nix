{modulesPath, lib, config, ...}: {
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix") 
        ../../users/mast3r.nix
        ../../setup/grub.nix
        ../../setup/locale.nix
        ../../setup/packages.nix
        ../../modules/plasma.nix
    ];

    fileSystems = {
        "/" = { 
            device = "/dev/disk/by-label/ROOT"; 
            fsType = "ext4";
        };
        "/boot" = { 
            device = "/dev/disk/by-label/BOOT"; 
            fsType = "vfat";
        };
        "/games" = { 
            device = "/dev/disk/by-label/GAMES"; 
            fsType = "ext4";
        };
        "/files" = { 
            device = "/dev/disk/by-label/FILES"; 
            fsType = "ext4";
        };
        swapDevices = [];
    };  
    
    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];
    
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    system.stateVersion = "24.05";
}