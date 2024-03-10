{pkgs, lib, modulesPath, config, ...}: {
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        ../users/mast3r.nix

        ../setup/packages.nix
        ../setup/locale.nix
        ../setup/grub.nix
        ../setup/networking.nix

        ../services/graphical.nix
        ../services/virtual-machines.nix
        ../services/ssh.nix
    ];
    
    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" = { 
        device = "/dev/disk/by-label/ROOT";
        fsType = "ext4";
    };

    boot.initrd.luks.devices."luks-03ac14ed-49f8-4bb0-af37-e82da1377dfd".device = "/dev/disk/by-uuid/03ac14ed-49f8-4bb0-af37-e82da1377dfd";

    fileSystems."/boot" = { 
        device = "/dev/disk/by-label/BOOT";
        fsType = "vfat";
    };
    fileSystems."/home" = {
        device = "/dev/disk/by-label/HOME";
        fsType = "ext4";
    };

    swapDevices = [{ 
        device = "/dev/disk/by-uuid/8a5eb8dd-89c7-4a8d-a12e-71e32d025acf"; 
    }];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    environment.systemPackages = with pkgs; [
        vim 
        source-code-pro
        openvpn
        htop
        zsh
        zsh-syntax-highlighting
        zsh-autosuggestions
        nix-index
        ghc
        feh
    ];

    networking.hostName = "laptop";

}
