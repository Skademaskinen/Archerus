inputs:

{ pkgs, lib, ... }: let
    autoStart = attrs: lib.mergeAttrs { enable = true; autostart = true; } attrs;
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
            servers.pyright = autoStart {};
            servers.nixd = autoStart {};
            servers.hls = autoStart {
                installGhc = false;
            };
            servers.clangd = autoStart {};
            servers.omnisharp = autoStart {};
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
        colorschemes.nightfox = {
            enable = true;
            settings.transparent = true;
        };
        opts.background = "";
        colorscheme = "carbonfox";
    };
    home.packages = [ pkgs.neovim ];
}
