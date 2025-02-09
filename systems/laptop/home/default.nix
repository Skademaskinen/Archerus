{config, ...}:

{
    wayland.windowManager.sway = import ./sway;
    home = {
        stateVersion = "24.11";
    };
}
