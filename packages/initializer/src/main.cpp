#include "initializer.hpp"
#include "log.hpp"
#include "config.hpp"
#include "home_manager.hpp"
#include "nixos.hpp"

int main(int argc, char* argv[]) {
    LOG("initializing initializer");
    Config config;
    config.parse(argc, argv);
    LOG("Finished setting up config");
    switch(config.get_mode()) {
        case NixosMode: {
            Nixos nixos(config);
            Initializer initializer(nixos, config);
            initializer.execute_instructions();
            return 0;
        }
        case HomeManagerMode: {
            HomeManager homeManager(config);
            Initializer initializer(homeManager, config);
            initializer.execute_instructions();
            return 0;
        }

    }

}
