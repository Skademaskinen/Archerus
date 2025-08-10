{ lib, config, ... }:

{
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
        "${config.skade.projectsRoot}" = {
            device = "/dev/disk/by-label/STORAGE";
            fsType = "ext4";
        };
    };
    swapDevices = [{ device="/dev/disk/by-uuid/3aac8229-8ab1-4c0d-a2c6-d27859553817"; }];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
