{pkgs, ...}:

{
    imports = [
        ./keybinds.nix
        ./theme.nix
        ./plugins.nix
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
        ];
    };
}
