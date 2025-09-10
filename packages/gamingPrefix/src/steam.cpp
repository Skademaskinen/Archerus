#include <libarcherus/log.hpp>

#include "type.hpp"
#include "config.hpp"

class Steam : public Type {
    public:
        Steam(Config& config) : Type(config, "steam") {
            utils::log(Level(utils::Debug), "Constructed Steam");
        }
        void execute() override {
            set_environment();
            const auto& prefix = config.get_prefix();
            const auto& postfix = config.get_postfix();
            send_notification(prefix, postfix);
            const auto prefix_string = prefix.build(config.get_executables_config());
            const auto postfix_string = postfix.represent(config.get_command_parts());
            utils::log(Level(utils::Info), "Prefix: {}", prefix_string.c_str());
            utils::log(Level(utils::Info), "Postfix: {}", postfix_string.c_str());
            postfix.execute(config.get_executables_config(), prefix, config.get_command_parts());
        }
};

int main(int argc, char* argv[]) {
    utils::log(Level(utils::Info), "Running steam prefix");
    ExecutablesFile file;
    Config config(file);
    config.parse(argc, argv);
    Steam steam(config);
    steam.execute();
}
