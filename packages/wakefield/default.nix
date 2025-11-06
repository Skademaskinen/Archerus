{ pkgs, ... }:

# Package override inspired from https://github.com/tadfisher/flake/blob/e92fc8659ad10d694acaecea2e78cf38389c410d/pkgs/default.nix#L31
# With minor adjustments
pkgs.openjdk21.overrideAttrs (prev: {
    src = pkgs.fetchFromGitHub {
        owner = "openjdk";
        repo = "wakefield";
        rev = "16cb66c24910f24be44ac19949a8933c8afba848";
        hash = "sha256-sQ63/zPKOk2d0hBt5uVVaZT1RZKOaBwuXp/b8DVa5mI=";
    };
    buildInputs = prev.buildInputs ++ [
        pkgs.shaderc
        pkgs.wayland
    ];
    nativeBuildInputs = prev.nativeBuildInputs ++ [
        pkgs.shaderc
        pkgs.wayland
    ];
    configureFlags = prev.configureFlags ++ [
        "--with-libffi-include=${pkgs.libffi.dev}/include"
        "--with-libffi-lib=${pkgs.libffi.out}/lib"
        "--with-wayland-include=${pkgs.wayland.dev}/include"
        "--with-wayland-lib=${pkgs.wayland.out}/lib"
        "--with-vulkan-include=${pkgs.vulkan-headers}/include"
        "--with-vulkan-shader-compiler=glslc"
    ];
})
