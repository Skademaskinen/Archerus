#include "type.hpp"
#include "log.hpp"
#include "config.hpp"

class Steam : public Type {
    public:
        Steam(Config& config) : Type(config) {
            utils::log(Level(utils::Debug), "Constructed Steam");
        }
        void execute() override {
            set_environment();
            const auto& prefix = config.get_prefix();
            const auto& postfix = config.get_postfix();
            const auto prefix_string = prefix.build(config.get_executables_config());
            const auto postfix_string = postfix.build(config.get_command_parts());
            utils::log(Level(utils::Info), "Prefix: %s", prefix_string.c_str());
            utils::log(Level(utils::Info), "Postfix: %s", postfix_string.c_str());
            auto res = std::system((prefix_string + " " + postfix_string).c_str());
            utils::log(Level(utils::Debug), "Command result: %d", res);
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
