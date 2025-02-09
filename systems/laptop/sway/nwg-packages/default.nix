{pkgs, ...}:
with pkgs; 

[
    (import ./azote.nix { inherit pkgs; })
    foot
    gnome-themes-extra
    gopsuinfo
    grim
    gtklock
    gtklock-playerctl-module
    gtklock-powerbar-module
    gtklock-userinfo-module
    imagemagick
    jq
    libappindicator-gtk3
    networkmanagerapplet
    nwg-clipman
    nwg-displays
    nwg-dock
    nwg-drawer
    nwg-hello
    #nwg-icon-picker
    nwg-look
    nwg-menu
    nwg-panel
    #nwg-readme-browser
    #nwg-shell-config
    #nwg-shell-wallpapers
    papirus-icon-theme
    playerctl
    polkit_gnome
    slurp
    swappy
    swaybg
    swayidle
    swaylock
    swaynotificationcenter
    wl-clipboard
    wlsunset
    xdg-user-dirs
    xwayland
    firefox
]

