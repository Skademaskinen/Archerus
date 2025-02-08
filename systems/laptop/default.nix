{pkgs, ...}:

{
    programs.sway = {
        enable = true;
        package = pkgs.swayfx;
        extraOptions = ["--unsupported-gpu"];
    };
    services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        wayland.compositor = "weston";

    };

    system.stateVersion = "24.11";
}
