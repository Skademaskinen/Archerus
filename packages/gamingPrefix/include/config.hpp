#pragma once

#include <libarcherus/base_config.hpp>

#include "executables_file.hpp"
#include "prefix.hpp"
#include "postfix.hpp"

class Config : public archerus::BaseConfig {
    Prefix            prefix;
    Postfix           postfix;
    ExecutablesFile&  file;
    ExecutablesConfig executables_config;
    CommandParts      command_parts;
    bool              enableNotifications;
public:
    Config(ExecutablesFile&);

    const Prefix& get_prefix() const;
    const Postfix& get_postfix() const;
    const ExecutablesConfig& get_executables_config() const;
    const CommandParts& get_command_parts() const;
    const bool& notifications_enabled() const;
};
