{
    imports = [./pipewire.nix];
    services.xserver = {
        displayManager = {
            defaultSession = "plasma";
            autoLogin = {
                enable = true;
                user = "mast3r";
            };
        };
        desktopManager.plasma6.enable = true;
    };
}