{pkgs, ...}:

{
    environment.systemPackages = with pkgs; [
        alacritty
        cargo
        unzip
        nodejs
        discord
        spotify
        kdePackages.breeze-gtk
        kdePackages.breeze-icons
        gtk3
        gobject-introspection
        feh
        neovide
        jetbrains.rider
        mono
        (pkgs.python312.withPackages (py: with py; [
            pillow
        ]))
        vlc
        # tak jonathan
        (pkgs.writeScriptBin "or" ''
            #!${pkgs.bash}/bin/bash
            systemd-run --user ${jetbrains.rider}/bin/rider $@
        '')
        jetbrains.idea-community
        jdk23
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
