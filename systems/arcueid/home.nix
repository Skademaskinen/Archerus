{ pkgs, ... }:

{
    home.stateVersion = "24.11";
    wayland.windowManager.hyprland.extraConfig = ''
        monitor = DP-1, 3840x2160, 0x0, 2
        monitor = DP-2, 3840x2160, 1920x0, 2
        exec-once "${pkgs.ckb-next}/bin/ckb-next -b"
    '';
}
