inputs:

{ pkgs, lib, ... }: let
    autoStart = { enable = true; autostart = true; };
    autoEnable = { enable = true; autoLoad = true; };
in

{
    imports = [
        inputs.nixvim.homeManagerModules.default
    ];
    programs.nixvim = {
        enable = true;
        vimAlias = true;
        extraConfigLua = ''
            vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
            vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
            vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
            vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting
            vim.g.autoformat = false
        '';
        extraPackages = with pkgs; [
            jdk23
            dotnet-sdk_8
        ];
        keymaps = [
            {
                key = "<A-i>";
                action = "<Cmd>ToggleTerm direction=float<CR>";
                mode = "n";
            }
            {
                key = "<A-i>";
                action = "<Cmd>ToggleTerm direction=float<CR>";
                mode = "t";
            }
            {
                key = "<A-j>";
                action = "<Cmd>Neotree toggle<CR>";
                mode = "n";
            }
            {
                key = "<C-n>";
                action = "<Cmd>Neotree focus<CR>";
                mode = "n";
            }
            {
                key = "<C-s>";
                action = "<Cmd><ESC>w<CR>";
                mode = "n";
            }
            {
                key = "<C-s>";
                action = "<Cmd>w<CR>";
                mode = "i";
            }
            {
                key = "<A-t>";
                action = "<Cmd>Trouble diagnostics toggle<CR>";
                mode = "n";
            }
        ];

        plugins.lsp = {
            enable = true;
            inlayHints = true;
            servers.pyright = autoStart;
            servers.nixd = autoStart;
            servers.hls = autoStart // {
                installGhc = false;
            };
            servers.clangd = autoStart;
            servers.omnisharp = autoStart;
        };
        #plugins.nvim-jdtls = {
        #    enable = true;
        #    data = "/home/mast3r/.cache/jdtls/workspace";
        #    jdtLanguageServerPackage = pkgs.jdt-language-server.override {
        #        jdk = pkgs.jdk23;
        #    };
        #};
        plugins.lsp-lines = autoEnable;
        plugins.lsp-signature = autoEnable;
        plugins.lsp-status = autoEnable;
        plugins.trouble = autoEnable;
        plugins.fugitive = autoEnable;
        plugins.barbar = autoEnable;
        plugins.noice = autoEnable // {
            settings.presets = {
                command_palette = true;
            };
        };
        plugins.notify = autoEnable;
        plugins.fzf-lua = autoEnable;
        plugins.treesitter = autoEnable;
        plugins.telescope = autoEnable;
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
        plugins.lualine = autoEnable // {
            settings.options.globalstatus = true;
        };
        plugins.cmp = autoEnable // {
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
        plugins.haskell-scope-highlighting = autoEnable;
        plugins.cmp-nvim-lsp = autoEnable;
        plugins.cmp-path = autoEnable;
        plugins.cmp-buffer = autoEnable;
        plugins.web-devicons = autoEnable;

        plugins.neo-tree = {
            enable = true;
            closeIfLastWindow = true;
            sourceSelector = {
                winbar = true;
                statusline = true;
            };
        };
        plugins.lspkind = { enable = true; };
        plugins.gitgutter = autoEnable // {
            recommendedSettings = true;
        };

        plugins.toggleterm = autoEnable // {
            settings.winbar.enabled = true;
        };
        colorschemes.nightfox = {
            enable = true;
            settings.transparent = true;
        };
        #opts.background = "";
        colorscheme = "carbonfox";

    };
}
