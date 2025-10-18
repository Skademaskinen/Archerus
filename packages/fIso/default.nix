{ nixos-generators, system, self, home-manager, pkgs, ... }:


nixos-generators.nixosGenerate {
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
        }
    ];
}
