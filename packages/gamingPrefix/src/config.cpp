#include "config.hpp"
#include "executables_file.hpp"
#include "log.hpp"
#include "prefix.hpp"

std::map<std::string, utils::LogLevel> loglevel_mapping {
    {"debug", utils::Debug},
    {"info",  utils::Info},
    {"warn",  utils::Warn},
    {"error", utils::Error}
};

Config::Config(ExecutablesFile& file) : BaseConfig("gaming prefix"), file(file), prefix(file) {
    parser.add_argument("--loglevel")
        .action([](std::string level) {
            utils::currentLevel = loglevel_mapping[level];
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
    utils::log(Level(utils::Debug), "Constructed config");
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
