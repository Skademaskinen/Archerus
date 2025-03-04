{pkgs, ...}:

{
    environment.systemPackages = with pkgs; [
        lutris
        bottles
        protonup-qt
    ];
    fonts.packages = with pkgs; [
        fira
        fira-mono
        nerdfonts
    ];


}
