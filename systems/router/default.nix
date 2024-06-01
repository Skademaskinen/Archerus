{pkgs, lib, modulesPath, ...}: {
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
    ];

    # HWCONFIG
    boot.initrd = {
        availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk"];
        kernelModules = [];
    };
    boot.kernelModules = [];
    boot.extraModulePackages = [];

    fileSystems = {
        "/" = {
            device = "/dev/disk/by-label/ROOT";
            fsType = "ext4";
        };
        "/boot" = {
            device = "/dev/disk/by-label/BOOT";
            fsType = "vfat";
            options = ["fmask=0077" "dmask=0077"];
        };
    };

    swapDevices = [];

    networking.useDHCP = lib.mkDefault true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    
    boot.loader.grub = {
        enable = true;
        device = "/dev/disk/by-label/BOOT";

    };
    system.stateVersion = "24.05";
}
