{ nixos-generators, nixpkgs, system, self, home-manager, pkgs, ... }:


let
    iso = nixos-generators.nixosGenerate {
        inherit system;
        format = "install-iso";
        modules = with self.nixosModules; [
            common
            desktop
            plymouth
            home-manager.nixosModules.default
            {
                services.displayManager.defaultSession = "hyprland";
                services.displayManager.autoLogin = {
                    enable = true;
                    user = "fember";
                };
                system.stateVersion = "25.05";
                users.users.fember = {
                    isNormalUser = true;
                    password = "fember";
                    shell = pkgs.zsh;
                    extraGroups = [ "wheel" "networkmanager" ];
                };

                boot.initrd.systemd.enable = pkgs.lib.mkForce false;
                programs.zsh.enable = true;
                users.groups.fember = {};
                home-manager.users.fember.imports = with self.homeManagerModules; [
                    common
                    hyprland
                    hyprland-themes.fklub
                    kitty
                    zsh
                    neovim
                    {
                        home.stateVersion = "25.05";
                    }
                ];

                networking.networkmanager.enable = pkgs.lib.mkForce false;
                networking.hostName = "F-NixOS";
                isoImage = {
                    makeEfiBootable = true;
                    makeUsbBootable = true;
                    volumeID = "F_NIXOS_ISO";
                    isoName = "F-NixOS.iso";
                    squashfsCompression = "zstd -Xcompression-level 3";
                };

                boot = {
                    supportedFilesystems = pkgs.lib.mkForce [ "ext4" "xfs" "vfat" ];
                    loader.systemd-boot = {
                        enable = true;
                    };
                };
                environment.variables = {
                    WLR_NO_HARDWARE_CURSORS = "1";
                };
                environment.systemPackages = [
                    archerusPkgs.electronApps.stregsystemet
                    archerusPkgs.electronApps.fikien
                    archerusPkgs.electronApps.nixosSearch
                ];
            }
        ];
    };
in
    iso.overrideAttrs {
        passthru.vm = pkgs.writeShellScriptBin "F-NixOS-vm" ''
            #!${pkgs.bash}/bin/bash
            ${pkgs.qemu}/bin/qemu-system-x86_64 -cdrom ${iso}/iso/${iso.isoName} -m 2048 -device virtio-vga-gl -display sdl,gl=on,show-cursor=off
        '';
    }
