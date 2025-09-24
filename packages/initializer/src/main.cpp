#include <libarcherus/log.hpp>

#include "initializer.hpp"
#include "config.hpp"
#include "home_manager.hpp"
#include "nixos.hpp"

int main(int argc, char* argv[]) {
    utils::log(Level(Debug), "initializing initializer");
    Config config;
    config.parse(argc, argv);
    utils::log(Level(Info), "Finished setting up config");
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
