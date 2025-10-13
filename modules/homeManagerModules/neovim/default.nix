inputs:

{ pkgs, lib, ... }: let
    autoStart = { enable = true; autostart = true; };
    autoEnable = { enable = true; autoLoad = true; };

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
            key = "<leader>n";
            action = "<Cmd>Neotree toggle<CR>";
            mode = "n";
            description = "Toggle Neotree";
        }
        {
            key = "<leader>t";
            action = "<Cmd>Trouble diagnostics toggle<CR>";
            mode = "n";
            description = "Toggle Trouble diagnostics";
        }
        {
            key = "<leader>c";
            action = ":CopilotChatToggle<CR>";
            mode = "n";
            description = "Toggle Copilot Chat";
        }
    ];
in

{
    imports = [
        inputs.nixvim.homeManagerModules.default
        (import ./keymaps.nix keymaps)
        ./theme.nix
        #./copilot.nix
    ];
    programs.nixvim = {
        enable = true;
        vimAlias = true;
        nixpkgs.useGlobalPackages = true;
        extraConfigLua = builtins.readFile ./default.lua;

        extraPackages = with pkgs; [
            jdk23
            dotnet-sdk_8
            curl
            ollama-rocm
        ];
        extraPlugins = with pkgs; [
            vimPlugins.haskell-vim
        ];

        plugins.lsp = {
            enable = true;
            inlayHints = true;
            servers.pyright = autoStart;
            servers.nixd = autoStart;
            servers.hls = autoStart // {
                installGhc = false;
            };
            servers.cmake = autoStart;
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

        plugins.lualine = autoEnable // {
            settings.options.globalstatus = true;
        };
        plugins.cmp = autoEnable // {
            autoEnableSources = true;
            settings.sources = [
                { name = "nvim_lsp"; priority = 400; }
                { name = "path"; priority = 300; }
                { name = "buffer"; priority = 200; }
                #{ name = "copilot"; priority = 100; }
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
            settings.winbar.name_formatter = ''
                function(term)
                    return fmt("%d:%s", term.id, term:_display_name())
                end
            '';
        };
        plugins.nvim-autopairs = autoEnable;

        globals = {
            mapleader = " ";
        };
    };
}
