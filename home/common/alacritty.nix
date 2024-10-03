{pkgs, lib, ...}:

{
    programs.alacritty = {
        enable = true;
        settings = {
            window.opacity = 0.90;
            window.padding = {
                x = 5;
                y = 5;
            };
            colors.primary.background = "#000000";
            font = lib.mergeAttrs {
                size = 12.0;
            }
            (builtins.mapAttrs (name: value: {
                family = value;
            }) {
                normal = "FiraCode Nerd Font";
                italic = "FiraCode Nerd Font";
                bold = "FiraCode Nerd Font";
                bold_italic = "FiraCode Nerd Font";
            });

            cursor.style.shape = "Underline";
            cursor.style.blinking = "On";
        };
    };
}