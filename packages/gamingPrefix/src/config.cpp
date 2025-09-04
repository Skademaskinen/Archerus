#include "config.hpp"
#include "executables_file.hpp"
#include "prefix.hpp"

Config::Config(ExecutablesFile& file) : BaseConfig("gaming prefix"), file(file), prefix(file) {
    parser.add_argument("--wayland")
        .store_into(wayland);
    for(auto& executable : file.get_executables()) {
        parser.add_argument("--" + executable.get_name())
            .store_into(executables_config[executable.get_name()])
            .default_value(false).implicit_value(true);
    }
    parser.add_argument("rest")
        .remaining()
        .store_into(command_parts);
    LOG("Constructed config");
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

const bool& Config::get_wayland() const {
    return wayland;
}
