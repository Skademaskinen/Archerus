{ pkgs, ... }: {
    programs.nixvim = {
        colorschemes.nightfox = {
            enable = true;
            autoLoad = true;
            settings.transparent = true;
        };
        opts.background = "";
        colorscheme = "carbonfox";
    };

}
