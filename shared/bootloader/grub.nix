{pkgs, ...}:

{
    boot.loader.grub = {
        enable = true;
        efiSupport = true;
        useOSProber = true;
        device = "nodev";
        splashImage = "${pkgs.nixos-artwork.wallpapers.nineish-dark-gray}/share/backgrounds/nixos/nix-wallpaper-nineish-dark-gray.png";
        theme = pkgs.sleek-grub-theme.override {
            withStyle = "dark";
            withBanner = "Laptop";
        };
    };
        
    boot.loader.efi.canTouchEfiVariables = true;

    boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
}
