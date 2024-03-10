{pkgs, config, lib, modulesPath, ...}: {
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        ../../users/mast3r.nix
        ../../users/taoshi.nix
        ../../modules/jupyter.nix
        ../../modules/lavalink.nix
        ../../modules/minecraft.nix
        ../../modules/mysql.nix
        ../../modules/nextcloud.nix
        ../../modules/nginx.nix
        ../../modules/Putricide.nix
        ../../modules/SketchBot.nix
        ../../modules/ssh.nix
        ../../modules/vpn.nix
        ../../modules/website.nix
        ../../modules/rp-utils.nix
        ../../setup/systemd-boot.nix
        ../../setup/locale.nix
        ../../setup/networking.nix
        ../../setup/packages.nix
        ../../setup/security.nix
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


    environment.systemPackages = with pkgs; [
        vim 
        openvpn
        mdadm
        mariadb_1011
        htop
        zsh
        zsh-syntax-highlighting
        zsh-autosuggestions
        nix-index
        ghc
        feh
        nextcloud27
        zulu
    ];

    system.autoUpgrade = {
        enable = true;
        flags = [
            "--update-input"
            "nixpkgs"
            "-I"
            "nixos-config=/etc/nixos"
        ];
        dates = "02:00";
        allowReboot = true;
    };

    
    networking.hostName = "Skademaskinen";

    system.stateVersion = "23.05";
}
