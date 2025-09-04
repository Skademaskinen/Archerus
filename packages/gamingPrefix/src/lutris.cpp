#include "log.hpp"
#include "type.hpp"
#include "config.hpp"
#include <cstdlib>

class Lutris : public Type {
    public:
        Lutris(Config& config) : Type(config) {
            LOG("Constructed lutris");
        }
        void execute() override {
            set_environment();
            const Prefix& prefix = config.get_prefix();
            const Postfix& postfix = config.get_postfix();
            const auto prefix_string = prefix.build(config.get_executables_config());
            const auto postfix_string = postfix.build(config.get_command_parts());
            LOG("Prefix: %s", prefix_string.c_str());
            LOG("Postfix: %s", postfix_string.c_str());
            std::system((prefix_string + " " + postfix_string).c_str());
        }
};

int main(int argc, char* argv[]) {
    LOG("Running lutris prefix");
    ExecutablesFile file;
    Config config(file);
    config.parse(argc, argv);
    Lutris lutris(config);
    lutris.execute();
}
