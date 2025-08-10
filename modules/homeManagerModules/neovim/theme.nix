{
    programs.nixvim = {
            plugins.transparent = {
            enable = true;
            settings.groups = [
                "Normal"
                "NormalNC"
                "NeoTreeNormal"
                "NeoTreeNormalNC"
                "TroubleNormal"
                "TroubleNormalNC"
                "BarbarNC"
                "Fidget"
                "FidgetNC"
                "LineNr"
                "Title"
            ];
        };

        colorschemes.nightfox = {
            enable = true;
            settings.transparent = true;
        };
        colorscheme = "carbonfox";
    };
}
