inputs @ { self, nixpkgs, archerusPkgs, lib, system, ... }:

# This is a custom build lenovo thinkpad l13 gen 6 AMD 2-in-1 variant
# Getting this half-tablet to work well will be fun!

nixpkgs.lib.nixosSystem {
    inherit system;
    modules = with self; [
        inputs.home-manager.nixosModules.default
        nixosModules.common
        nixosModules.desktop
        nixosModules.gaming
        nixosModules.grub
        nixosModules.plymouth
        nixosModules.programming
        nixosModules.users.mast3r
        ({ pkgs, config, ... }:

        {
            imports = [
                ./hardware-configuration.nix
                inputs.nixos-hardware.nixosModules.lenovo-thinkpad
            ];
            home-manager.users.mast3r.imports = [
                homeManagerModules.common
                homeManagerModules.hyprland
                homeManagerModules.hyprland-themes.main
                homeManagerModules.alacritty
                homeManagerModules.kitty
                homeManagerModules.spotify
                (lib.load ./home.nix)
            ];
            services.displayManager.defaultSession = "hyprland";
            services.displayManager.autoLogin = {
                #user = "mast3r";
                #enable = true;
            };
            networking.hostName = lib.capitalize (builtins.baseNameOf ./.);
            system.stateVersion = "25.11";

            services.fprintd.enable = true;

            nixpkgs.config.allowUnfree = true;

            programs.nix-ld.enable = true;

            hardware.graphics.enable = true;

            environment.systemPackages = [
                archerusPkgs.electronApps.chatgpt
                archerusPkgs.electronApps.youtube
                archerusPkgs.electronApps.stregsystemet
                archerusPkgs.electronApps.fikien
                archerusPkgs.electronApps.nixosSearch
                archerusPkgs.electronApps.pathbuilder
                archerusPkgs.nixLauncher
                pkgs.vesktop
                pkgs.firefox
                pkgs.discord
            ];

            programs.iio-hyprland.enable = true;
            hardware.sensor.iio.enable = true;

            # suspend bug workaround
            # The wifi module is the same as one of the newer framework AI laptops, so this is copied from there
            # see https://community.frame.work/t/framework-13-ryzen-ai-350-wont-suspend-in-linux-due-to-mt7925e/70830/4
            systemd.services = {
                mt7925e-sleep = {
                     description = "Unload mt7925e wifi driver before sleep";
                     before = [
                        "hibernate.target"
                        "suspend.target"
                     ];
                     wantedBy = [
                        "hibernate.target"
                        "suspend.target"
                     ];
                     serviceConfig = {
                        ExecStart = "${pkgs.kmod}/bin/modprobe -r mt7925e";
                     };
                };
                mt7925e-resume = {
                    description = "Reload mt7925e wifi driver after resume from sleep";
                    after = [
                        "hibernate.target"
                        "suspend.target"
                    ];
                    wantedBy = [
                        "hibernate.target"
                        "suspend.target"
                    ];
                    serviceConfig = {
                        ExecStartPre = "${pkgs.kmod}/bin/modprobe -r mt7925e";
                        ExecStart = "${pkgs.kmod}/bin/modprobe mt7925e";
                    };
                };
            };

            # Gaming
            # Since this is a personal laptop just for on the go gaming and programming, i thin its fine to have some gaming setup
            hardware.bluetooth = {
                enable = true;
                powerOnBoot = true;
                settings.General = {
                    experimental = true;
                    Privacy = "device";
                    JurtWorksRepairing = "always";
                    Class = "0x000100";
                    FastConnectable = true;
                };
            };
            services.blueman.enable = true;

            hardware.xpadneo.enable = true;
            boot.extraModulePackages = [
                config.boot.kernelPackages.xpadneo
            ];
            boot.extraModprobeConfig = ''
                options bluetooth disable_ertm=Y
            '';

            programs.steam.gamescopeSession = {
                enable = true;
            };
        })
    ];
}
