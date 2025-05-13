inputs:

{ pkgs, ... }:

{
    programs.git = {
        enable = true;
    };

    home.packages = with pkgs; [
        jetbrains.rider
    ];
}
