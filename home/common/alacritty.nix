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
            font = lib.mergeAttrs {
                size = 12.0;
            }
            (builtins.mapAttrs (name: value: {
                family = value;
            }) {
                normal = "Fira Code";
                italic = "Fira Code";
                bold = "Fira Code";
                bold_italic = "Fira Code";
            });

            cursor.style.shape = "Underline";
            cursor.style.blinking = "On";

            colors = (builtins.fromTOML (builtins.readFile (pkgs.alacritty-theme + /pastel_dark.toml))).colors;
        } ;
    };
}
