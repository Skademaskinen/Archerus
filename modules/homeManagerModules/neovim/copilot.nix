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
        plugins.copilot-chat = {
            enable = true;
            settings = {
                window = {
                    layout = "float";
                    border = "rounded";
                    title = "🤖 AI Assistant";
                    zindex = 100;
                };

                headers = {
                    user = "👤 You";
                    assistant = "🤖 Copilot";
                    tool = "🔧 Tool";
                };

                separator = "━━";
                auto_fold = true;
            };
        };
    };
}
