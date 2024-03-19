{pkgs, config, lib, ...}: {

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

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
            fsType = "ntfs";
        };
    };
    swapDevices = [];

    services.xserver.videoDrivers = [ "amdgpu" ];
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    system.stateVersion = "24.05";

    networking.hostName = "desktop";
    networking.interfaces.enp39s0.wakeOnLan.enable = true;

    environment.variables = {
        XCURSOR_SIZE="48";
    };
    
    services.xserver = {
        enable = true;
        xkb.layout = "dk";
        xkb.variant = "winkeys";
        displayManager.sddm.enable = true;
    };

    hardware.ckb-next.enable = true;
    programs.steam.enable = true;
    programs.gamescope.enable = true;
    programs.gamemode.enable = true;

    # custom pkgs
    wow.warcraftlogs.enable = true;
}