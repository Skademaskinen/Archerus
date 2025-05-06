{pkgs, ...}:

{
    boot.loader.grub = {
        enable = true;
        efiSupport = true;
        useOSProber = true;
        device = "nodev";
        efiInstallAsRemovable = true;
        splashImage = "${pkgs.nixos-artwork.wallpapers.nineish-dark-gray}/share/backgrounds/nixos/nix-wallpaper-nineish-dark-gray.png";
        theme = (pkgs.sleek-grub-theme.override {
            withStyle = "dark";
            withBanner = "Laptop";
        }).overrideAttrs {
            postInstallPhase = ''
                sed "2d" $out/theme.txt | sed '2i desktop-color: "#F0F0F000"' > $out/theme.txt
            '';
        };
        extraEntries = ''
            menuentry "Reboot" {
                reboot
            }
            menuentry "Poweroff" {
                halt
            }
        '';
    };
}
