{
    boot.loader.grub = {
        enable = true;
        efiSupport = true;
        useOSProber = true;
        device = "nodev";
        splashImage = "/etc/nixos-assets/wallpaper.png";
    };
        
    boot.loader.efi.canTouchEfiVariables = true;

    boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
}
