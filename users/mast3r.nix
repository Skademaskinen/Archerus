{ config, lib, pkgs, modulesPath, ... }: {
    users.users.mast3r = {
        isNormalUser = true;
        description = "mast3r";
        extraGroups = [ "networkmanager" "wheel" "wireshark" "libvirtd" "tty" "dialout" "input" ];
        shell = pkgs.zsh;
        hashedPassword = "$6$rounds=2000000$htFKKf65jcKCw09Z$JNmYnL5lIBZP6dvqYXUmj0vzzaiRteXOwlJzkcYcRCYdT5Zt8TVJWvtT4w4Q8suBneVOLEjxsMIf0yEY4BDrz1";

        packages = with pkgs; [
            jq
            git
            (python311.withPackages(pyPkgs: with pyPkgs; [
                ipython 
                bcrypt 
                matplotlib 
                sqlite 
                bash_kernel 
                python-nmap
            ]))
            sqlite-interactive
            git
            neofetch
            sshfs
            nixpkgs-fmt
            texliveFull
            wol
            cmake
            bat
            sqlite
            screen
            wget
            lynx
            termshark
            texliveFull
            font-awesome
            ((vim_configurable.override{}).customize{
                name = "vim";
                vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
                    start = [yuck-vim nerdtree supertab airline ale syntastic vital tabular];
                    opt = [];
                };
                vimrcConfig.customRC = builtins.readFile ../files/.vimrc;

            })
        ];
    };
    environment.variables = {EDITOR="vim";};

    users.mutableUsers = false;

}
