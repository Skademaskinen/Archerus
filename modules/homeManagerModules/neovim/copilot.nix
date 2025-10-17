{ pkgs, ... }:


{
    programs.nixvim = {
        plugins.copilot-lua = {
            enable = true;
            autoLoad = true;
            settings.suggestion.enabled = false;
            settings.panel.enabled = false;
        };
        plugins.copilot-cmp = {
            enable = true;
            autoLoad = true;
            settings.suggestion = {
                enabled = false;
                #autoTrigger = "always";
                debounce = 50;
            };
            settings.panel = {
                enabled = true;
            };
        };
    };
}
