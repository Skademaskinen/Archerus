#include "home_manager.hpp"
#include "log.hpp"
#include <filesystem>
#include <vector>

HomeManager::HomeManager(Config& config) : Type(config, "/home/" + config.get_username() + "/.config/home-manager/flake.nix", config.get_home_flake_template_path()) {
    substitution_pairs["user"] = config.get_username();
    LOG("initialized Home manager");
}

void HomeManager::extra_init() {
    auto prefix = config.get_desktop_prefix();
    for(const auto& file : {"hyprland.desktop", "sway.desktop"}) {
        std::filesystem::copy(prefix + file, std::string("/usr/share/wayland-sessions/") + file);
    }
}
