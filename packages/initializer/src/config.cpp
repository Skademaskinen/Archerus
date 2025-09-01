#include "config.hpp"
#include <cstdlib>

Config::Config() : BaseConfig("Initializer") {
    parser.add_argument("--desktop_prefix", "-d")
        .help("Path to the .desktop file parent dir of hyprland and sway files")
        .default_value(".");
    parser.add_argument("--hostname", "-H")
        .help("Hostname of the current machine")
        .default_value("nixos");
    parser.add_argument("--username", "-U")
        .help("Username of the target user")
        .default_value("mast3r");
    parser.add_argument("--home_template")
        .help("Path to the template flake for home-manager")
        .default_value("./home-mananger-flake.nix");
    parser.add_argument("--nixos_template")
        .help("Path to the template flake for nixos")
        .default_value("./nixos-flake.nix");
    parser.add_argument("mode")
        .required()
        .nargs(1)
        .choices("nixos", "home")
        .action([this](std::string arg){
            mode = ((std::map<std::string, Mode>){{ "nixos", NixosMode }, { "home", HomeManagerMode }})[arg];
        });
    parser.add_argument("instructions")
        .required()
        .choices("initialize", "switch")
        .action([this](std::string arg){
            instructions.push_back(instructions::to_instruction(arg));
        });
}

const Mode& Config::get_mode() const {
    return mode;
}

const std::vector<instructions::Instruction>& Config::get_instructions() const {
    return instructions;
}

const std::string Config::get_desktop_prefix() const {
    return parser.get("--desktop_prefix") + "/";
}

const std::string Config::get_hostname() const {
    return parser.get("--hostname");
}

const std::string Config::get_username() const {
    return parser.get("--username");
}

const std::string Config::get_home_flake_template_path() const {
    return parser.get("--home_template");
}

const std::string Config::get_nixos_flake_template_path() const {
    return parser.get("--nixos_template");
}
