{ config, lib, pkgs, modulesPath, ... }: {
    users.users.mast3r = {
    isNormalUser = true;
    description = "mast3r";
    extraGroups = [ "networkmanager" "wheel" "wireshark" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      #neofetch
      jdk21
      git
      neovim
      python311
      bat
      sqlite
      screen
      maven
      ghc
      unzip
      pfetch
      tmux
      ihaskell
      nmap
      firefox
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
          start = [yuck-vim nerdtree];
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
            nnoremap <C-Left> :tabprevious<CR>
            nnoremap <C-Right> :tabnext<CR>
            nmap <cr> :$tabnew<CR>
            nnoremap <C-Up> :NERDTree<CR>
            set backspace=indent,eol,start
        '';
      })

    ];
  };
  
}
