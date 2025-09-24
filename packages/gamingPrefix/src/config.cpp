#include <libarcherus/log.hpp>

#include "config.hpp"
#include "executables_file.hpp"
#include "prefix.hpp"

Config::Config(ExecutablesFile& file) : BaseConfig("gaming prefix"), file(file), prefix(file) {
    parser.add_argument("--loglevel")
        .action([](std::string level) {
            utils::currentLevel = utils::fromString(level);
        });
    parser.add_argument("--disable_notifications")
        .default_value(true)
        .implicit_value(false)
        .store_into(enableNotifications);
    for(auto& executable : file.get_executables()) {
        parser.add_argument("--" + executable.get_name())
            .store_into(executables_config[executable.get_name()])
            .default_value(false).implicit_value(true);
    }
    parser.add_argument("rest")
        .remaining()
        .store_into(command_parts);
    utils::log(Level(Debug), "Constructed config");
}

const Prefix& Config::get_prefix() const {
    return prefix;
}

const Postfix& Config::get_postfix() const {
    return postfix;
}

const ExecutablesConfig& Config::get_executables_config() const {
    return executables_config;
}

const CommandParts& Config::get_command_parts() const {
    return command_parts;
}

const bool& Config::notifications_enabled() const {
    return enableNotifications;
}
