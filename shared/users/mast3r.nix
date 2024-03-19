{pkgs, ...}: let
    vim = import ../programs/vim.nix { pkgs = pkgs; };
in {
    imports = [../programs/zsh.nix];
    users.users.mast3r = {
        isNormalUser = true;
        description = "mast3r";
        extraGroups = [ "networkmanager" "wheel" "wireshark" "libvirtd" "tty" "dialout" "input" ];
        shell = pkgs.zsh;
        hashedPassword = "$6$rounds=2000000$htFKKf65jcKCw09Z$JNmYnL5lIBZP6dvqYXUmj0vzzaiRteXOwlJzkcYcRCYdT5Zt8TVJWvtT4w4Q8suBneVOLEjxsMIf0yEY4BDrz1";
        packages = [ vim ];
    };
    programs.zsh.enable = true;
}