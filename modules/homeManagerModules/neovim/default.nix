{ pkgs, lib, nixvim, ... }:

{
    imports = [
        nixvim.homeModules.default
        ./theme.nix
        ./lsp-cmp.nix
        ./ui.nix
        ./keymaps.nix
        ./git.nix
        ./copilot.nix
    ];
    programs.nixvim = {
        enable = true;
        vimAlias = true;

        extraConfigLua = ''
            vim.o.tabstop = 4
            vim.o.expandtab = true
            vim.o.softtabstop = 4
            vim.o.shiftwidth = 4
            vim.g.autoformat = false
            
            vim.g.pyindent_open_paren = 0
            vim.g.pyindent_close_paren = 0
            vim.o.number = true
        '';
    };
}
