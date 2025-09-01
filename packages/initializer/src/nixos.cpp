#include "nixos.hpp"
#include "log.hpp"
#include <filesystem>

Nixos::Nixos(Config& config) : Type(config, "/etc/nixos/flake.nix", config.get_nixos_flake_template_path()) {
    substitution_pairs["host"] = config.get_hostname();
    LOG("Initialized NixOS");
}

void Nixos::extra_init() {
    LOG("Empty nixos extra_init");
}
