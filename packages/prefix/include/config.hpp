#pragma once

#include <libarcherus/base_config.hpp>
#include <libarcherus/config_file.hpp>

#include "executable.hpp"
#include "prefix_config.hpp"

class Config : public archerus::BaseConfig {
    std::vector<Executable> enabledExecutables;
    bool                     enableNotifications;
public:
    Config(const PrefixConfig&);

    const std::vector<Executable>& getEnabledExecutables() const;
    const bool& notificationsEnabled() const;
};
