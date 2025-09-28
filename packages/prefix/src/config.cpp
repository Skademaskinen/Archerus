#include <argparse/argparse.hpp>
#include <format>
#include <libarcherus/error_handling.hpp>
#include <libarcherus/log.hpp>
#include <libarcherus/config_file.hpp>
#include <libarcherus/vector_utils.hpp>

#include "config.hpp"
#include "prefix_config.hpp"

Config::Config(const PrefixConfig& pfxConfig) : BaseConfig("pfx") {
    parseLoglevel(parser);
    parser.add_argument("--disable_notifications")
        .help("Disable desktop notifications")
        .default_value(true)
        .implicit_value(false)
        .store_into(enableNotifications);
    parser.add_argument("part")
        .remaining()
        .nargs(argparse::nargs_pattern::any)
        .action([this, &pfxConfig](auto item){
            log(DEBUG, "Enabling {}...", item);
            // program should crash if the element doesn't exist, means there is no config for it
            try {
                auto& executable = pfxConfig.get() * [&item](const auto item1) {
                    return item == item1.getName();
                };
                enabledExecutables.push_back(executable);
            
            } catch (const std::exception& ex) {
                log(ERROR, "Executable not found in config!!! {}", ex.what());
                exit(ErrorCode::invalid_argument);
            }
        });
    log(DEBUG, "Constructed config");
}

const std::vector<Executable>& Config::getEnabledExecutables() const {
    return enabledExecutables;
}

const bool& Config::notificationsEnabled() const {
    return enableNotifications;
}
