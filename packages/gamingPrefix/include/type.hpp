#pragma once

#include "log.hpp"
#include "prefix.hpp"
#include "postfix.hpp"
#include "config.hpp"
#include "vector_utils.hpp"
#include <cstdlib>

class Type {
protected:
    Config& config;
public:
    Type(Config& config) : config(config) {
        utils::log(Level(utils::Debug), "Constructed type");
    }
    virtual void execute() = 0;

    void set_environment() {
        for (const auto& [name, enabled] : config.get_executables_config()) {
            if (!enabled) {
                continue;
            }
            auto& executable = utils::find_element(config.get_prefix().get_executables(), [name](Executable executable) {
                return executable.get_name() == name;
            });
            auto environment = executable.get_environment();
            for (const auto& [name, value] : environment) {
                utils::log(Level(utils::Debug), "Env: %s -> %s", name.c_str(), value.c_str());
                setenv(name.c_str(), value.c_str(), 1);
            }
        }

    }
};
