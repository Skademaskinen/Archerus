{
  description = "Skademaskinen configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.backend = import ./packages/backend.nix {};

  };
}
