{ pkgs, ... }:

{
    programs.nixvim.plugins = {
        lualine = {
            enable = true;
            settings.options.globalstatus = true;
        };

        notify = {
            enable = true;
        };

        nui = {
            enable = true;
        };

        noice = {
            enable = true;
            settings = {
                lsp = {
                    hover.enabled = true;
                    message = {
                        enabled = true;
                        view = "notify";
                    };
                };

                presets = {
                    bottom_search = false;
                    command_palette = true;
                    long_message_to_split = true;
                    inc_rename = true;
                    lsp_doc_border = true;
                };

                routes = [
                    {
                        filter = {
                            event = "msg_show";
                            any = [
                                { find = "%d+L, %d+B"; }
                                { find = "; after #%d+"; }
                                { find = "; before #%d+"; }
                            ];
                        };
                        view = "notify";
                    }
                ];
            };
        };
        telescope = {
            enable = true;
            extensions = {
                fzf-native.enable = true;
                ui-select.enable = true;
            };
        };
        neo-tree = {
            enable = true;
            closeIfLastWindow = true;
            sourceSelector = {
                winbar = true;
                statusline = true;
            };
        };
        dashboard = {
            enable = true;
            settings.config = {
                header = pkgs.lib.splitString "\n" (builtins.readFile (pkgs.runCommand "header.txt" {} ''
                    ${pkgs.figlet}/bin/figlet -f speed neovim > $out
                ''));
            };
        };
        treesitter = {
            enable = true;
        };

        web-devicons = {
            enable = true;
        };

        toggleterm = {
            enable = true;
            settings.winbar.enabled = true;
            settings.winbar.name_formatter = ''
                function(term)
                    return fmt("%d: %s", term.id, term:_display_name())
                end
            '';
        };

        bufferline = {
            enable = true;
        };

        nvim-autopairs = {
            enable = true;
        };
    };
}
