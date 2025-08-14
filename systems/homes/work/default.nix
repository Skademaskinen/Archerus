{ home-manager, self, nixpkgs, nixGL, ... }:

home-manager.lib.homeManagerConfiguration {
    modules = with self.homeManagerModules; [
        common
        hyprland
        sway
        kitty
        alacritty
        neovim
        zsh
    ] ++ [({ pkgs, ... }: {  
        home.username = "work";
        home.homeDirectory = "/home/work";
        home.stateVersion = "25.05";
        home.packages = with pkgs; [
            nixgl.nixGLIntel
            home-manager
            (writeScriptBin "init-desktop-files" ''
                #!${pkgs.bash}/bin/bash
                set -e
                TMP=$(mktemp -d)
                SWAY_DESKOP=${pkgs.sway-unwrapped}/share/wayland-sessions/sway.desktop
                HYPRLAND_DESKTOP=${pkgs.hyprland}/share/wayland-sessions/hyprland.desktop
                cp $SWAY_DESKOP $TMP/sway.desktop
                cp $HYPRLAND_DESKTOP $TMP/hyprland.desktop
                ${pkgs.gnused}/bin/sed -i 's|Exec=sway|Exec=${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${pkgs.sway-unwrapped}/bin/sway|g' $HYPRLAND_DESKTOP
                ${pkgs.gnused}/bin/sed -i 's|Exec=Hyprland|Exec=${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${pkgs.Hyprland}/bin/Hyprland|g' $HYPRLAND_DESKTOP
                sudo cp $TMP/* /usr/share/wayland-sessions
            '')
        ];
    })];
    pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ nixGL.overlay ];
    };
}
