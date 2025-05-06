{pkgs, ...}:

{
    # packages
    environment.systemPackages = with pkgs; [
        alacritty
        cargo
        unzip
        nodejs
        vesktop
        discord
        spotify
        kdePackages.breeze-gtk
        kdePackages.breeze-icons
        gtk3
        gobject-introspection
        feh
        mono
        vlc
        teams-for-linux
        signal-desktop
    ];
    fonts.packages = with pkgs; [
        fira
        fira-mono
        nerdfonts
    ];



}
