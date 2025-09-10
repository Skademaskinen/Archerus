#include <filesystem>

#include <libarcherus/log.hpp>

#include "nixos.hpp"

Nixos::Nixos(Config& config) : Type(config, "/etc/nixos/flake.nix", config.get_nixos_flake_template_path()) {
    substitution_pairs["host"] = config.get_hostname();
    utils::log(Level(utils::Debug), "Initialized NixOS");
}

void Nixos::extra_init() {
    utils::log(Level(utils::Warn), "Empty nixos extra_init");
}
