{pkgs, config, lib, modulesPath, ...}: {
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix") 
        ./packages.nix
    ];

    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    boot.initrd.kernelModules = [ ];
    boot.initrd.luks.devices."luks-03ac14ed-49f8-4bb0-af37-e82da1377dfd".device = "/dev/disk/by-uuid/03ac14ed-49f8-4bb0-af37-e82da1377dfd";
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    fileSystems = {
        "/" = {
            device = "/dev/disk/by-label/ROOT";
            fsType = "ext4";
        };
        "/boot" = {
            device = "/dev/disk/by-label/BOOT";
            fsType = "vfat";
        };
        "/home" = {
            device = "/dev/disk/by-label/HOME";
            fsType = "ext4";
        };

    };
    swapDevices = [{ 
        device = "/dev/disk/by-uuid/8a5eb8dd-89c7-4a8d-a12e-71e32d025acf"; 
    }];

    networking.hostName = "laptop";

    system.stateVersion = "24.05";

    services.xserver = {
        enable = true;
        xkb.layout = "dk";
        xkb.variant = "winkeys";
        displayManager.sddm.enable = true;
    };

    hardware.ckb-next.enable = true;

    programs.steam.enable = true;
    
    programs.wireshark.enable = true;

    # custom options
    globalEnvs.python.enable = true;
    services.jupyter.enable = true;
    users.users.jupyter.group = "jupyter";
    users.groups.jupyter = {};
    services.jupyter.password = "1234";
    services.jupyter.kernels = let
        env = (pkgs.python311.withPackages (py: with py; [
            bash_kernel
            ipykernel
        ]));
    in {
        "bash" = {
            language = "bash";
            argv = ["${env.interpreter}" "-m" "bash_kernel" "-f" "{connection_file}"];
        };
    };

    fonts.packages = with pkgs; [
        comic-mono
        (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];

    systemd.services.protonmail-bridge = {
        enable = true;
        serviceConfig = {
            ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --no-window --noninteractive";
            User = "mast3r";
        };
        wantedBy = ["default.target"];
    };
    services.gnome.gnome-keyring.enable = true;

}
