#pragma once

#include <cstdlib>
#include <format>

#include "glib-object.h"
#include "log.hpp"
#include "prefix.hpp"
#include "postfix.hpp"
#include "config.hpp"
#include "utils.hpp"
#include "vector_utils.hpp"

#include <libnotify/notify.h>

class Type {
protected:
    Config& config;
    std::string name;
public:
    Type(Config& config, std::string name) : config(config), name(name) {
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

    void send_notification(const Prefix& prefix, const Postfix& postfix) {
        if (!notify_is_initted()) {
            notify_init(name.c_str());
        }
        std::string header = std::format("Launching {} Game", name);
        std::string body = std::format(
            R"(
    command: {}
    enabled parts: 
    {}
            )", 
            postfix.represent(config.get_command_parts()),
            utils::concat_elements(prefix.get_enabled_executables(config.get_executables_config()), [](Executable executable){
                return executable.get_name() + "\n\t";
            })
        );

        // C code
        {
            NotifyNotification* n = notify_notification_new(header.c_str(), body.c_str(), std::getenv("GAMING_PREFIX_ICON"));
            notify_notification_show(n, nullptr);

            g_object_unref(G_OBJECT(n));
        }
    }
};
