#include <libarcherus/error_handling.hpp>
#include <libarcherus/log.hpp>
#include <libarcherus/utils.hpp>

#include "type.hpp"
#include "config.hpp"

class Steam : public Type {
    public:
        Steam(Config& config) : Type(config, "steam") {
            log(DEBUG, "Constructed Steam");
        }
        void execute() override {
            set_environment();
            const auto& prefix = config.get_prefix();
            const auto& postfix = config.get_postfix();
            send_notification(prefix, postfix);
            const auto prefix_string = prefix.build(config.get_executables_config());
            const auto postfix_string = postfix.represent(config.get_command_parts());
            log(INFO, "Prefix: {}", prefix_string.c_str());
            log(INFO, "Postfix: {}", postfix_string.c_str());
            postfix.execute(config.get_executables_config(), prefix, config.get_command_parts());
        }
};

Main(Argv& args) {
    log(INFO, "Running steam prefix");
    ExecutablesFile file;
    Config config(file);
    config.parse(args);
    Steam steam(config);
    steam.execute();
    return ErrorCode::success;
}
