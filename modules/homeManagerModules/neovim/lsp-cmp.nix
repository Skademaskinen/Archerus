{
    programs.nixvim.plugins = {
        lsp = {
            enable = true;
            inlayHints = true;
            servers = {
                pyright.enable = true;
                nixd.enable = true;
                hls = {
                    enable = true;
                    installGhc = false;
                };
                cmake.enable = true;
                clangd.enable = true;
            };
        };

        tiny-inline-diagnostic = {
            enable = true;
            settings = {
                preset = "powerline";
                options = {
                    show_all_diags_on_cursorline = true;
                    multilines = {
                        enabled = true;
                        always_show = true;
                    };
                };
            };
        };

        lsp-signature = {
            enable = true;
        };

        cmp = {
            enable = true;
            autoEnableSources = true;
            settings.sources = [
                { name = "nvim_lsp"; priority = 400; }
                { name = "path"; priority = 300; }
                { name = "buffer"; priority = 200; }
                { name = "copilot"; priority = 100; }
            ];
            settings.mapping = {
                "<C-Space>" = "cmp.mapping.complete()";
                "<C-d>" = "cmp.mapping.scroll_docs(-4)";
                "<C-e>" = "cmp.mapping.close()";
                "<C-f>" = "cmp.mapping.scroll_docs(4)";
                "<CR>" = "cmp.mapping.confirm({ select = true })";
                "<C-Up>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
                "<C-Down>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            };
        };

        trouble = {
            enable = true;
        };
    };

}
