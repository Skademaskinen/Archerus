{pkgs, ...}:

{
    boot = {
        plymouth = {
            enable = true;
            theme = "nixos-bgrt";
            themePackages = [
                pkgs.kdePackages.breeze-plymouth
                pkgs.plymouth-matrix-theme
                pkgs.plymouth-proxzima-theme
                pkgs.nixos-bgrt-plymouth
            ];
            font = "${pkgs.fira}/share/fonts/opentype/FiraMono-Medium.otf";
        };
        consoleLogLevel = 0;
        initrd.verbose = false;
        initrd.systemd.enable = true;
        kernelParams = [
            "quiet"
            "splash"
            "boot.shell_on_fail"
            "loglevel=3"
            "rd.systemd.show_status=false"
            "rd.udev.log_level=3"
            "udev.log_priority=3"
        ];
        #loader.timeout = 0;

    };
}
