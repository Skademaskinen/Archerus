{ pkgs, ... }: {
    programs.nixvim = {
        colorschemes.nightfox = {
            enable = true;
            settings.transparent = true;
        };
        opts.background = "";
        colorscheme = "carbonfox";
    };

}
