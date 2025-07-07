keymaps: {
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
