{ config, lib, pkgs, modulesPath, ... }: {
    users.users.mast3r = {
        isNormalUser = true;
        description = "mast3r";
        extraGroups = [ "networkmanager" "wheel" "wireshark" "libvirtd" "tty" "dialout" ];
        shell = pkgs.zsh;
        hashedPassword = "$6$rounds=2000000$htFKKf65jcKCw09Z$JNmYnL5lIBZP6dvqYXUmj0vzzaiRteXOwlJzkcYcRCYdT5Zt8TVJWvtT4w4Q8suBneVOLEjxsMIf0yEY4BDrz1";

        packages = with pkgs; [
            firefox
            discord
            konsole
            jdk21
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
            font-awesome
            gtklock
            libreoffice
            swaybg
            git
            neofetch
            vscode
            libnotify
            direnv
            gtk3
            sshfs
            nixpkgs-fmt
            gparted
            spotify
            mangohud
            texliveFull
            haskell-language-server
            gimp
            wol
            zotero
            alsa-utils
            cmake
            bat
            sqlite
            screen
            maven
            ghc
            unzip
            pfetch
            tmux
            nmap
            wget
            lynx
            libsForQt5.plasma-workspace
            termshark
            texliveFull
            gradle
            gnumake
            gcc
            ((vim_configurable.override{}).customize{
                name = "vim";
                vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
                    start = [yuck-vim nerdtree supertab airline ale syntastic vital tabular];
                    opt = [];
                };
                vimrcConfig.customRC = ''
                    set tabstop=4
                    set shiftwidth=4 smarttab
                    set expandtab
                    set number
                    set nowrap
                    syntax on
                    set mouse=a
                    colorscheme slate
                    hi Normal guibg=NONE cterm=NONE
                    set sidescroll=1
                    set cursorline
                    hi CursorLine gui=underline cterm=underline
                    set termwinsize=10x0
                    cd %:p:h
                    autocmd BufReadPost *
                        \ if line("\"") > 0 && line("'\"") <= line ("$") |
                        \ exe "normal! g`\"" |
                        \ endif
                    let &t_SI = "\e[5 q"
                    let &t_EI = "\e[6 q"
                    set wildmenu
                    nmap <silent> <C-Left> :tabprevious<CR>
                    nmap <silent> <C-Right> :tabnext<CR>
                    nmap <silent> <cr> :$tabnew<CR>
                    nmap <silent> <Tab> :NERDTree<CR>
                    nmap <silent> <C-Q> :q<CR>
                    nmap <silent> <C-W> :w<CR>
                    nmap <silent> <C-X> :x<CR>
                    nmap <silent> <C-T> :bot term<CR>
                    nmap <silent> <C-S-Up> :wincmd k<CR>
                    nmap <silent> <C-S-Down> :wincmd j<CR>
                    nmap <silent> <C-S-Left> :wincmd h<CR>
                    nmap <silent> <C-S-Right> :wincmd l<CR>
                    tnoremap <silent> <C-S-Up> <c-\><c-n> 
                    set backspace=indent,eol,start
                '';

            })
        ];
    };
    environment.variables = {EDITOR="vim";};

    users.mutableUsers = false;

}
