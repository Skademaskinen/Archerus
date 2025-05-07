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
            servers.clangd = autoEnable' {};
            servers.omnisharp = autoEnable' {};
        };
        #plugins.nvim-jdtls = {
        #    enable = true;
        #    data = "/home/mast3r/.cache/jdtls/workspace";
        #    jdtLanguageServerPackage = pkgs.jdt-language-server.override {
        #        jdk = pkgs.jdk23;
        #    };
        #};
        plugins.lsp-lines = { enable = true; };
        plugins.lsp-status = { enable = true; };
        plugins.trouble = { enable = true; };
        plugins.fugitive = { enable = true; };
        plugins.barbar = { enable = true; };
        plugins.noice = { enable = true; };
        plugins.notify = { enable = true; };
        plugins.fzf-lua = { enable = true; };
        plugins.treesitter = { enable = true; };
        plugins.telescope = { enable = true; };
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
            ];
        };
        plugins.lualine = {
            enable = true;
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
        plugins.haskell-scope-highlighting = { enable = true; };
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
        plugins.gitgutter = {
            enable = true;
            recommendedSettings = true;
        };

        plugins.toggleterm = {
            enable = true;
            settings.winbar.enabled = true;
        };
    };
}
