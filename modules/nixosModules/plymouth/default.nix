inputs:

{ pkgs, ... }:

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
            logo = "${pkgs.fetchFromGitHub {
                owner = "Mast3rwaf1z";
                repo = "homepage";
                rev = "master";
                hash = "sha256-biwdNDCLu4p9T0m/Uhdh1gMBVS5VbI9dW7eSrL18KtU=";
            }}/static/icon.png";
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
