{ self, ... }:

{ pkgs, config, ... }:

{
    users.users.mast3r = {
        isNormalUser = true;
        hashedPassword = "$y$j9T$I5fyCjf3pYZTZjXYaPHtI/$88R1u4uNP6yCs8GCy5aXmyDVm7AVeyASoYOOuouh0k3";
        shell = pkgs.zsh;
        extraGroups = [ "wheel" "networkmanager" ];
    };
    programs.zsh.enable = true;
    users.groups.mast3r = {};
        home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.mast3r.imports = [
                self.homeManagerModules.neovim
                self.homeManagerModules.zsh
                { home.stateVersion = config.system.stateVersion; }
            ];

        };
}
