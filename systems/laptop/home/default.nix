{config, pkgs, ...}:

{
    imports = [
        ./sway
    ];
    home = {
        stateVersion = "24.11";
        packages = with pkgs; [
            dconf
            nixos-icons    
            (pkgs.writeScriptBin "mage" ''
                ${tmux}/bin/tmux new-session -d sh -c "cd ~/Games/xmage/xmage/mage-server && ${jdk8}/bin/java -jar ~/Games/xmage/xmage/mage-server/lib/mage-server-1.4.56.jar"
                _JAVA_AWT_WM_NONREPARENTING=1 sh -c "cd ~/Games/xmage/xmage/mage-client && ${jdk8}/bin/java -jar ~/Games/xmage/xmage/mage-client/lib/mage-client-1.4.56.jar"
                ${tmux}/bin/tmux kill-session
            '')
        ];
    };
    
    gtk = {
        enable = true;
        cursorTheme.name = "Vimix-cursors";
        cursorTheme.package = pkgs.vimix-cursors;
        font.name = "Noto Sans, 10";
        font.package = pkgs.noto-fonts;
        iconTheme.name = "breeze-dark";
        iconTheme.package = pkgs.kdePackages.breeze;
        theme.name = "Adwaita-dark";
        theme.package = pkgs.gnome-themes-extra;
    };
    qt = {
        enable = true;
        platformTheme.name = "gtk";
    };

}
