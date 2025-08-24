{ self, nyx, ... }:

{ pkgs, config, ... }:

{
    users.users.mast3r = {
        isNormalUser = true;
        hashedPassword = "$y$j9T$I5fyCjf3pYZTZjXYaPHtI/$88R1u4uNP6yCs8GCy5aXmyDVm7AVeyASoYOOuouh0k3";
        shell = pkgs.zsh;
        extraGroups = [ "wheel" "networkmanager" ];
        # run everything in wayland unless i explicitly tell it to run in xwayland
        packages = with pkgs; [
            quickemu
            (writeScriptBin "x" ''
                export DISPLAY=:0
                $@
            '')
            (writeScriptBin "w" ''
                export DISPLAY=""
                $@
            '')
        ];
    };
    programs.zsh.enable = true;
    users.groups.mast3r = {};
    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.mast3r.imports = [
            nyx.homeManagerModules.default
            self.homeManagerModules.neovim
            self.homeManagerModules.zsh
            {
                home.stateVersion = config.system.stateVersion;
                nyx = {
                    enable = true;
                    username = "mast3r";
                    nixDirectory = "/etc/nixos";
                    logDir = "/home/mast3r/.nyx/logs";
                    autoPush = false;
                
                    nyx-tool.enable = true;
                    nyx-rebuild.enable = true;
                };
            }
        ];

    };
}
