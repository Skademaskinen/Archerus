{ pkgs, ... }: 

{
    wayland.windowManager.hyprland.extraConfig = ''
        monitor = eDP-1, 1920x1200, 0x0, 1
    '';

    home.file = {
        ".local/share/bolt-launcher/runelite.jar".source = "${pkgs.runelite}/share/RuneLite.jar";
    };
}
