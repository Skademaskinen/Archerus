inputs: 

{ pkgs, ... }:

{
    programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        shellAliases = {
            switch = "sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch";
            boot = "sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild boot";
            build-vm = "${pkgs.nixos-rebuild}/bin/nixos-rebuild build-vm";
            edit = "vim /skademaskinen/Server-Config";
            cat = "${pkgs.bat}/bin/bat -pp";
        };
        prezto = {
            enable = true;
            prompt.theme = "minimal";
        };
    };

}
