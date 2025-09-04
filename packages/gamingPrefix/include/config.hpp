#pragma once

#include <map>
#include <string>

#include "base_config.hpp"
#include "executables_file.hpp"
#include "prefix.hpp"
#include "postfix.hpp"

typedef std::vector<std::string> CommandParts;

class Config : public BaseConfig {
    Prefix prefix;
    Postfix postfix;
    bool wayland;
    ExecutablesFile& file;
    ExecutablesConfig executables_config;
    CommandParts command_parts;
public:
    Config(ExecutablesFile&);

    const Prefix& get_prefix() const;
    const Postfix& get_postfix() const;
    const ExecutablesConfig& get_executables_config() const;
    const CommandParts& get_command_parts() const;
    const bool& get_wayland() const;
};
