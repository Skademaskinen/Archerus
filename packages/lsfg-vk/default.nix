{ nixpkgs, lib, ... }:

# All credit goes to https://github.com/PancakeTAS/lsfg-vk/pull/53#issuecomment-3066948757

let
    pkgs = lib.load nixpkgs;
in pkgs.callPackage ({
  stdenv,
  fetchurl,
  jq,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lsfg-vk";
  version = "nightly";
  src = fetchurl {
    url = "https://pancake.gay/lsfg-vk/lsfg-vk.zip";
    hash = "sha256-RvPqXo4B0PHFIxD58JGO6SKcidwekBeIIZZi1+ej6Zo=";
  };

  nativeBuildInputs = [
    unzip
    jq
  ];

  dontUnpack = true;
  dontBuild = true;
   
  installPhase = ''
      unzip $src

      vk_so="$out/lib/liblsfg-vk.so"
      mkdir -p "$(dirname "$vk_so")"
      mv lib/liblsfg-vk.so "$vk_so"

      vk_json="$out/share/vulkan/implicit_layer.d/VkLayer_LS_frame_generation.json"
      mkdir -p "$(dirname $vk_json)"
      jq ".layer.library_path = \"$vk_so\"" < share/vulkan/implicit_layer.d/VkLayer_LS_frame_generation.json > "$vk_json"
    '';
})) {}
