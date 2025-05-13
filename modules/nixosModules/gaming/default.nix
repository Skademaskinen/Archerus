inputs:

{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        lutris
        wine
        protonup-qt
        discord
        vesktop
        inputs.self.packages.${inputs.system}.bolt
    ];

    nixpkgs.config.allowUnfree = true;

    programs.steam.enable = true;
    programs.gamescope.enable = true;
}
