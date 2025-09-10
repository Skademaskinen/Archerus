#include <cstdlib>

#include <libarcherus/log.hpp>

#include "type.hpp"
#include "config.hpp"

class Lutris : public Type {
    public:
        Lutris(Config& config) : Type(config, "lutris") {
            utils::log(Level(utils::Debug), "Constructed lutris");
        }
        void execute() override {
            set_environment();
            const Prefix& prefix = config.get_prefix();
            const Postfix& postfix = config.get_postfix();
            send_notification(prefix, postfix);
            const auto prefix_string = prefix.build(config.get_executables_config());
            const auto postfix_string = postfix.represent(config.get_command_parts());
            utils::log(Level(utils::Info), "Prefix: {}", prefix_string.c_str());
            utils::log(Level(utils::Info), "Postfix: {}", postfix_string.c_str());
            postfix.execute(config.get_executables_config(), prefix, config.get_command_parts());
        }
};

int main(int argc, char* argv[]) {
    utils::log(Level(utils::Info), "Running lutris prefix");
    ExecutablesFile file;
    Config config(file);
    config.parse(argc, argv);
    Lutris lutris(config);
    lutris.execute();
}
