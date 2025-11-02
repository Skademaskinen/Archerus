{ pkgs, lib, nixvim, ... }:

{
    imports = [
        nixvim.homeModules.default
        (lib.load ./theme.nix)
        (lib.load ./lsp-cmp.nix)
        (lib.load ./ui.nix)
        (lib.load ./keymaps.nix)
        (lib.load ./git.nix)
        (lib.load ./copilot.nix)
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

        extraPlugins = [
            pkgs.vimPlugins.haskell-vim
            pkgs.vimPlugins.haskell-tools-nvim
        ];
    };
}
