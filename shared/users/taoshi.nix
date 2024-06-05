{pkgs, ...}: {
    imports = [
        ../programs/zsh.nix
        ../programs/vim.nix
    ];
    users.users.taoshi = {
        isNormalUser = true;
        description = "taoshi";
        extraGroups = [ "networkmanager" "wheel" ];
        shell = pkgs.zsh;        
        hashedPassword = "$6$q/mbB8rHd0SyPKzp$4A/alC2VNtl1Hfi2jTmq/c4TputBM8FRoiuLO6Vif9OEN3Js9.X9JXHDBj6Cmsp1xaX9CCB4MIbhKSmqsi6K0.";
        packages = [ vim ];
    };
    programs.zsh.enable = true;
}
