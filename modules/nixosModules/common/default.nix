inputs:

{ pkgs, lib, ... }:

{
    options.skade.type = lib.mkOption {
        type = lib.types.str;
        default = "desktop";
    };
    config = {
        environment.systemPackages = with pkgs; [
            vim
        ];
        networking.networkmanager.enable = true;
    
        nixpkgs.config.allowUnfree = true;
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
    
        time.timeZone = "Europe/Copenhagen";
    
        i18n.defaultLocale = "en_DK.UTF-8";
    
        i18n.extraLocaleSettings = {
            LC_ADDRESS = "da_DK.UTF-8";
            LC_IDENTIFICATION = "da_DK.UTF-8";
            LC_MEASUREMENT = "da_DK.UTF-8";
            LC_MONETARY = "da_DK.UTF-8";
            LC_NAME = "da_DK.UTF-8";
            LC_NUMERIC = "da_DK.UTF-8";
            LC_PAPER = "da_DK.UTF-8";
            LC_TELEPHONE = "da_DK.UTF-8";
            LC_TIME = "da_DK.UTF-8";
        };
    
        services.openssh.enable = true;
    
        # Nix has been buggy lately
        nix.package = pkgs.lix;
    };
}
