inputs:

{ pkgs, lib, ... }:

{
    programs.kitty = {
        enable = true;

        font = {
            size = 12.0;
            name = "FiraCode Nerd Font";
        };

        settings = {
            background_opacity = "0.9";
            confirm_os_window_close = 0;
            scrollback_lines = 10000;

            cursor_shape = "underline";
            cursor_blink_interval = 0.5; # kitty doesn't support 'blinking=On' directly

            # Kitty doesn't have window padding options like alacritty, ignored

            # Colors - black background
            background = "#000000";

            # Optional: mimic pastel_dark if you want to convert TOML theme manually
            # Otherwise, leave it minimal or use a known theme
            foreground = "#eaeaea";
            color0 = "#2c2c2c";
            color1 = "#fc5d7c";
            color2 = "#9ed072";
            color3 = "#e7c664";
            color4 = "#76cce0";
            color5 = "#b39df3";
            color6 = "#f39660";
            color7 = "#eeeeee";
            color8 = "#3f3f3f";
            color9 = "#fc5d7c";
            color10 = "#9ed072";
            color11 = "#e7c664";
            color12 = "#76cce0";
            color13 = "#b39df3";
            color14 = "#f39660";
            color15 = "#ffffff";
        };
        actionAliases.ssh = "kitten ssh";
    };
}

