inputs @ { self, nixpkgs, ... }:

(nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    # First modules
    modules = (map (module: self.nixosModules.${module}) [
        "desktop"
        "gaming"
        "server"
        "common"
        "programming"
    # Then regular depends
    ]) ++ (map (input: inputs.${input}.nixosModules.default) [
        "home-manager"
        "homepage"
        "rp-utils"
        "putricide"
    ]) ++ [({ pkgs, ... }:

    {
        users.users.tester = {
            isNormalUser = true;
            password = "tester";
            group = "tester";
        };
        users.groups.tester = {};

        home-manager.users.tester = import ./home inputs;
        environment.systemPackages = with pkgs; [
            neovim
        ];
        system.stateVersion = "25.05";
    }) (import ./configs.nix inputs)];
}).config.system.build.vm
