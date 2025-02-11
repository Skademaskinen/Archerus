{pkgs, ...}:

{
    boot.loader.grub = {
        enable = true;
        efiSupport = true;
        useOSProber = true;
        device = "nodev";
        splashImage = "${pkgs.nixos-artwork.wallpapers.stripes-logo}/share/wallpapers/stripes-logo-2016-02-19/contents/images/nix-wallpaper-stripes-logo.png";
    };
        
    boot.loader.efi.canTouchEfiVariables = true;

    boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
}
