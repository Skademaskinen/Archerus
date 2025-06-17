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
        nixpkgs.useGlobalPackages = true;
        extraConfigLua = builtins.readFile ./nixvim.lua;

        extraPackages = with pkgs; [
            jdk23
            dotnet-sdk_8
            curl
            ollama-rocm
        ];
        extraPlugins = with pkgs; [
            vimPlugins.haskell-vim
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
        plugins.lsp-lines = autoEnable;
        plugins.tiny-inline-diagnostic = autoEnable;
        plugins.fidget = { enable = true; };
        #plugins.lsp-signature = autoEnable;
        plugins.lsp-status = autoEnable;
        plugins.trouble = autoEnable;
        plugins.fugitive = autoEnable;
        plugins.bufferline = autoEnable;
        plugins.noice = autoEnable // {
            settings.presets = {
                command_palette = true;
            };
        };
        #plugins.notify = autoEnable;
        plugins.fzf-lua = autoEnable;
        plugins.treesitter = autoEnable // {
            grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
                python
                nix
                haskell
            ];
            settings.highlight.enable = true;
        };
        #plugins.telescope = autoEnable;
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
                "Fidget"
                "FidgetNC"
                "LineNr"
                "Title"
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
        plugins.nvim-autopairs = autoEnable;

        colorschemes.nightfox = {
            enable = true;
            settings.transparent = true;
        };
        colorscheme = "carbonfox";

        #autoCmd = [
        #    {
        #        event = [ "BufReadPost" ];
        #        pattern = [ "*" ];
        #        callback = ''
        #            local mark = vim.api.nvim_buf_get_mark(0, '"')
        #            local lcount = vim.api.nvim_buf_line_count(0)
        #            if mark[1] > 0 and mark[1] <= lcount then
        #                pcall(vim.api.nvim_win_set_cursor, 0, mark)
        #            end
        #        '';
        #    }
        #];
    };
}
