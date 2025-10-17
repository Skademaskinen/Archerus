inputs:

let
    keymaps = [
        {
            key = "<leader>i";
            action = "<Cmd>ToggleTerm direction=float<CR>";
            mode = "n";
            description = "Toggle terminal in float mode";
        }
        {
            key = "<A-i>";
            action = "<Cmd>ToggleTerm direction=float<CR>";
            mode = "n";
            description = "Toggle terminal in float mode";
        }
        {
            key = "<A-i>";
            action = "<Cmd>ToggleTerm direction=float<CR>";
            mode = "t";
            description = "Toggle terminal in float mode";
        }
        {
            key = "<A-n>";
            action = "<Cmd>Neotree toggle<CR>";
            mode = "n";
            description = "Toggle Neotree";
        }
        {
            key = "<A-c>";
            action = ":CopilotChatToggle<CR>";
            mode = "n";
            description = "Toggle Copilot Chat";
        }

    ];
in

{
    programs.nixvim = {
        plugins.which-key = {
            enable = true;
            autoLoad = true;
            settings.plugins.presets = {
                operators = true;
                motions = true;
                text_objects = true;
                windows = true;
                nav = true;
                z = true;
                g = true;
            };
            settings.spec = map (km: {
                __unkeyed = km.key;
                group = km.description;
                mode = km.mode;
                desc = km.description;
            }) keymaps;
        };

        keymaps = map (km: {
            key = km.key;
            action = km.action;
            mode = km.mode;
        }) keymaps;
    };
}
