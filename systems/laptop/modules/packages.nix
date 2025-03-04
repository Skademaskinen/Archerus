{pkgs, ...}:

{
    environment.systemPackages = with pkgs; [
        lutris
        bottles
        protonup-qt
        teams-for-linux
    ];
    fonts.packages = with pkgs; [
        fira
        fira-mono
        nerdfonts
    ];


}
