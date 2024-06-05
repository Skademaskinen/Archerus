{pkgs, lib, config, ...}: {
    options.globalEnvs = {
        python = {
            enable = lib.mkOption {
                type = lib.types.bool;
                default = false;
            };
            extraPackages = lib.mkOption {
                type = lib.types.listOf lib.types.package;
                default = [];
            };
        };
    };
        config.environment.systemPackages = if config.globalEnvs.python.enable then [(pkgs.python311.withPackages (py: with py; [
            bash_kernel
            pytest
            sympy
            numpy
            scikit-learn
        ]))] else [];
}
