#include "type.hpp"
#include "log.hpp"
#include "config.hpp"

class Steam : public Type {
    public:
        Steam(Config& config) : Type(config) {
            LOG("Constructed Steam");
        }
        void execute() override {
            set_environment();
            const auto& prefix = config.get_prefix();
            const auto& postfix = config.get_postfix();
            const auto prefix_string = prefix.build(config.get_executables_config());
            const auto postfix_string = postfix.build(config.get_command_parts());
            LOG("Prefix: %s", prefix_string.c_str());
            LOG("Postfix: %s", postfix_string.c_str());
            std::system((prefix_string + " " + postfix_string).c_str());
        }
};

int main(int argc, char* argv[]) {
    LOG("Running steam prefix");
    ExecutablesFile file;
    Config config(file);
    config.parse(argc, argv);
    Steam steam(config);
    steam.execute();
}
