{pkgs, lib, ...}: let
    autoEnable = attrs: lib.mergeAttrs { enable = true; autoLoad = true; } attrs;
    autoEnable' = attrs: lib.mergeAttrs { enable = true; autostart = true; } attrs;

in {
    programs.nixvim = {
        plugins.lsp = {
            enable = true;
            inlayHints = true;
            servers.pyright = autoEnable' {};
            servers.nixd = autoEnable' {};
            servers.hls = autoEnable' {
                installGhc = false;
            };
        };
        plugins.nvim-jdtls = {
            enable = true;
            jdtLanguageServerPackage = pkgs.jdt-language-server.override {
                jdk = pkgs.jdk23;
            };
        };
        plugins.lsp-lines = autoEnable {};
        plugins.lsp-status = autoEnable {};
        plugins.trouble = autoEnable {};
        plugins.fugitive = autoEnable {};
        plugins.barbar = autoEnable {};
        plugins.noice = autoEnable {};
        plugins.notify = autoEnable {};
        plugins.fzf-lua = autoEnable {};
        plugins.treesitter = autoEnable {};
        plugins.telescope = autoEnable {};
        plugins.transparent = autoEnable {
            settings.groups = [
                "Normal"
                "NormalNC"
                "NeoTreeNormal"
                "NeoTreeNormalNC"
                "TroubleNormal"
                "TroubleNormalNC"
                "BarbarNC"
            ];
        };
        plugins.lualine = autoEnable {
            settings.options.globalstatus = true;
        };
        plugins.cmp = {
            enable = true;
            autoEnableSources = false;
            settings.sources = [
                { name = "nvim_lsp"; }
                { name = "path"; }
                { name = "buffer"; }
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
        plugins.haskell-scope-highlighting = autoEnable {};
        plugins.cmp-nvim-lsp.enable = true;
        plugins.cmp-path.enable = true;
        plugins.cmp-buffer.enable = true;
        plugins.web-devicons.enable = true;

        plugins.neo-tree = {
            enable = true;
            closeIfLastWindow = true;
            sourceSelector = {
                winbar = true;
                statusline = true;
            };
        };
        plugins.lspkind = {
            enable = true;
        };
        plugins.gitgutter = autoEnable {
            recommendedSettings = true;
        };

        plugins.toggleterm = {
            enable = true;
            settings.winbar.enabled = true;
        };
    };
}
