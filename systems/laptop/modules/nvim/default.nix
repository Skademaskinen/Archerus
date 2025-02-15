{
    programs.nixvim = {
        enable = true;
        vimAlias = true;
        plugins.lsp = {
            enable = true;
            servers.jdtls = {
                enable = true;
                autostart = true;
            };
            servers.pyright = {
                enable = true;
                autostart = true;
            };
            servers.nixd = {
                enable = true;
                autostart = true;
            };
        };
        plugins.transparent = {
            enable = true;
            autoLoad = true;
            settings.groups = [
                "Normal"
                "NormalNC"
                "NeoTreeNormal"
                "NeoTreeNormalNC"
            ];
        };
        plugins.airline = {
            enable = true;
            autoLoad = true;
            settings.powerline_fonts = 1;
        };
        plugins.fugitive = {
            enable = true;
            autoLoad = true;
        };
        plugins.barbar = {
            enable = true;
            autoLoad = true;
        };
        plugins.lazy.enable = true;
        plugins.neo-tree = {
            enable = true;
            closeIfLastWindow = true;
            sourceSelector.winbar = true;
            sourceSelector.statusline = true;
        };
        plugins.noice = {
            enable = true;
            autoLoad = true;
        };
        plugins.notify = {
            enable = true;
            autoLoad = true;
        };
        plugins.fzf-lua = {
            enable = true;
        };
        plugins.web-devicons.enable = true;

        plugins.toggleterm = {
            enable = true;
            settings.winbar.enabled = true;
        };
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
                key = "<C-s>";
                action = "<Cmd><ESC>w<CR>";
                mode = "n";
            }
            {
                key = "<C-s>";
                action = "<Cmd>w<CR>";
                mode = "i";
            }
        ];
        extraConfigLua = ''
            vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
            vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
            vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
            vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting
            vim.g.autoformat = false
        '';

        colorschemes.tokyonight = {
            enable = true;
            autoLoad = true;
            settings.transparent = true;
        };
    };
}
