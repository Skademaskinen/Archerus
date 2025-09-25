#include <libarcherus/log.hpp>

#include "initializer.hpp"
#include "config.hpp"
#include "home_manager.hpp"
#include "nixos.hpp"

Main(Argv& args) {
    log(DEBUG, "initializing initializer");
    Config config;
    config.parse(args);
    log(INFO, "Finished setting up config");
    switch(config.get_mode()) {
        case NixosMode: {
            Nixos nixos(config);
            Initializer initializer(nixos, config);
            initializer.execute_instructions();
            return ErrorCode::success;
        }
        case HomeManagerMode: {
            HomeManager homeManager(config);
            Initializer initializer(homeManager, config);
            initializer.execute_instructions();
            return ErrorCode::success;
        }

    }
    return ErrorCode::invalid_argument;

}
