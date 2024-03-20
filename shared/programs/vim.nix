{pkgs}: (pkgs.vim_configurable.override {}).customize {
    name = "vim";
    vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {opt=[]; start = [
        yuck-vim 
        nerdtree 
        supertab 
        airline 
        ale 
        syntastic  
        tabular
    ]; };
    vimrcConfig.customRC = builtins.readFile ../../files/.vimrc;
}