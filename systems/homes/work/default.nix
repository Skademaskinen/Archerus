{ home-manager, archerus, nixpkgs, nixGL, ... }:

home-manager.lib.homeManagerConfiguration {
    modules = with archerus.homeManagerModules; [
        common
        hyprland
        sway
        kitty
        alacritty
        neovim
        zsh
    ] ++ [({ pkgs, ... }: {  
        home.username = name;
        home.homeDirectory = "/home/${name}";
        home.stateVersion = "25.05";
        home.packages = with pkgs; [
            nixgl.nixGLIntel
            (writeScriptBin "init-desktop-files" ''
                SWAY_DESKOP=${pkgs.sway-unwrapped}/share/wayland-sessions/sway.desktop
                HYPRLAND_DESKTOP=${pkgs.hyprland}/share/wayland-sessions/hyprland.desktop
                ${pkgs.gnused}/bin/sed -i 's|Hyprland|${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${pkgs.Hyprland}/bin/Hyprland|g' $HYPRLAND_DESKTOP
                ${pkgs.gnused}/bin/sed -i 's|Hyprland|${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${pkgs.sway-unwrapped}/bin/sway|g' $HYPRLAND_DESKTOP
                ${pkgs.sudo}/bin/sudo cp $SWAY_DESKOP $HYPRLAND_DESKTOP /usr/share/wayland-sessions
            '')
        ];
    })];
    pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ nixGL.overlay ];
    };
}
