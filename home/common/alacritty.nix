{pkgs, ...}:

{
    programs.alacritty = {
        enable = true;
        settings = {
            window.opacity = 0.90;
            colors.primary.background = "#000000";
            font.size = 12.0;
            font.normal.family = "FiraCode Nerd Font";
            font.italic.family = "FiraCode Nerd Font";
            font.bold.family = "FiraCode Nerd Font";
            font.bold_italic.family = "FiraCode Nerd Font";

            cursor.style.shape = "Underline";
            cursor.style.blinking = "On";
        };
    };
}