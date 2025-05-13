inputs:

{ pkgs, ... }:

{
    boot = {
        plymouth = {
            enable = true;
            theme = "nixos-bgrt";
            themePackages = [
                (inputs.self.packages.${inputs.system}.plymouth-theme { logo = inputs.lib.wallpapers.flogo; })
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
