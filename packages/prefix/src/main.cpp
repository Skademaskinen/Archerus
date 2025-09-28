#include <cstdlib>

#include <libarcherus/config_file.hpp>
#include <libarcherus/log.hpp>
#include <libarcherus/utils.hpp>
#include <libarcherus/vector_utils.hpp>
#include <libnotify/notification.h>
#include <libnotify/notify.h>
#include <string>

#include "postfix.hpp"
#include "config.hpp"

class Executor {
    std::string name;
    Prefix prefix;
    Postfix postfix;
public:
    Executor(Prefix& prefix, Postfix& postfix) :
        prefix(prefix),
        postfix(postfix),
        name("pfx") {
        log(DEBUG, "Constructed type");
    }

    void setEnvironment() {
        for (const auto& executable : prefix.getExecutables()) {

            const auto& environment = executable.getEnvironment();
            for (const auto& [name, value] : environment) {
                log(DEBUG, "Env: {} -> {}", name.c_str(), value.c_str());
                setenv(name.c_str(), value.c_str(), 1);
            }
        }

    }

    void sendNotification(const Prefix& prefix, const Postfix& postfix) {
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
            postfix.represent(),
            prefix.getExecutables() + [](Executable executable){
                return executable.getName() + "\n\t";
            }
        );

        // C code
        {
            NotifyNotification* n = notify_notification_new(header.c_str(), body.c_str(), "/etc/archerus/prefix.png");
            notify_notification_show(n, nullptr);

            g_object_unref(G_OBJECT(n));
        }
    }

    void execute() {
        setEnvironment();
        const auto postfix_string = postfix.represent();
        sendNotification(prefix, postfix);
        const auto prefix_string = prefix.build();
        log(INFO, "Prefix: {}", prefix_string);
        log(INFO, "Postfix: {}", postfix_string);
        postfix.execute(prefix);
    }
};

Main(Argv& args) {
    const auto [ pfxargs, cmdargs ] = args | (std::string)"--";
    PrefixConfig pfxConfig;
    Config config(pfxConfig);
    config.parse(pfxargs);
    log(INFO, "Running prefix");
    Prefix prefix(config);
    Postfix postfix(cmdargs);
    Executor exe(prefix, postfix);
    exe.execute();
    return ErrorCode::success;
}
