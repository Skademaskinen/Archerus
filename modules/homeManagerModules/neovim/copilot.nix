
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
                autoTrigger = "always";
                debounce = 50;
            };
            settings.panel = {
                enabled = true;
            };
        };
        plugins.copilot-chat = {
            enable = true;
            autoLoad = true;
            settings.window.layout = "float";
            settings.window.width = 0.8;
            settings.window.height = 0.8;
        };
    };
}
