#include "log.hpp"
#include "type.hpp"
#include "config.hpp"
#include <cstdlib>

class Lutris : public Type {
    public:
        Lutris(Config& config) : Type(config) {
            utils::log(Level(utils::Debug), "Constructed lutris");
        }
        void execute() override {
            set_environment();
            const Prefix& prefix = config.get_prefix();
            const Postfix& postfix = config.get_postfix();
            const auto prefix_string = prefix.build(config.get_executables_config());
            const auto postfix_string = postfix.build(config.get_command_parts());
            utils::log(Level(utils::Info), "Prefix: %s", prefix_string.c_str());
            utils::log(Level(utils::Info), "Postfix: %s", postfix_string.c_str());
            auto res = std::system((prefix_string + " " + postfix_string).c_str());
            utils::log(Level(utils::Debug), "Command result: %d", res);
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
