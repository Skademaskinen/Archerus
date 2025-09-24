#include <filesystem>

#include <libarcherus/log.hpp>

#include "home_manager.hpp"
#include <filesystem>

HomeManager::HomeManager(Config& config) : Type(config, "/home/" + config.get_username() + "/.config/home-manager/flake.nix", config.get_home_flake_template_path()) {
    substitution_pairs["user"] = config.get_username();
    utils::log(Level(Debug), "initialized Home manager");
}

void HomeManager::extra_init() {
    auto prefix = config.get_desktop_prefix();
    for(const auto& file : {"hyprland.desktop", "sway.desktop"}) {
        std::filesystem::copy(prefix / file, std::filesystem::path("/usr/share/wayland-sessions") / file);
    }
}
