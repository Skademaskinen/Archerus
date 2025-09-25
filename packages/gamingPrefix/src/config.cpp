#include <libarcherus/log.hpp>

#include "config.hpp"
#include "executables_file.hpp"
#include "prefix.hpp"

Config::Config(ExecutablesFile& file) : BaseConfig("gaming prefix"), file(file), prefix(file) {
    parse_loglevel(parser);
    parser.add_argument("--disable_notifications")
        .help("Disable desktop notifications")
        .default_value(true)
        .implicit_value(false)
        .store_into(enableNotifications);
    for(auto& executable : file.get_executables()) {
        parser.add_argument("--" + executable.get_name())
            .help(std::format("Enable {}", executable.get_name()).c_str())
            .store_into(executables_config[executable.get_name()])
            .default_value(false).implicit_value(true);
    }
    parser.add_argument("rest")
        .help("The command to run with the prefix")
        .remaining()
        .store_into(command_parts);
    log(DEBUG, "Constructed config");
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
