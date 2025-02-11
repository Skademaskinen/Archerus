{pkgs, ...}:

{
    environment.systemPackages = with pkgs; [
        neovim
        alacritty
        cargo
        python3
        unzip
        nodejs
        discord
        spotify
        kdePackages.breeze-gtk
        kdePackages.breeze-icons
        gtk3
        gobject-introspection
        feh
    ];
    fonts.packages = with pkgs; [
        fira
        fira-mono
        nerdfonts
    ];


}
