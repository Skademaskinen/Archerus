#include <cstdlib>

#include <libarcherus/log.hpp>

#include "type.hpp"
#include "config.hpp"

class Lutris : public Type {
    public:
        Lutris(Config& config) : Type(config, "lutris") {
            log(DEBUG, "Constructed lutris");
        }
        void execute() override {
            set_environment();
            const Prefix& prefix = config.get_prefix();
            const Postfix& postfix = config.get_postfix();
            send_notification(prefix, postfix);
            const auto prefix_string = prefix.build(config.get_executables_config());
            const auto postfix_string = postfix.represent(config.get_command_parts());
            log(INFO, "Prefix: {}", prefix_string);
            log(INFO, "Postfix: {}", postfix_string);
            postfix.execute(config.get_executables_config(), prefix, config.get_command_parts());
        }
};

Main(Argv& args) {
    log(INFO, "Running lutris prefix");
    ExecutablesFile file;
    Config config(file);
    config.parse(args);
    Lutris lutris(config);
    lutris.execute();
    return ErrorCode::success;
}
