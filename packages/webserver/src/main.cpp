#include <argparse/argparse.hpp>
#include <libarcherus/log.hpp>

#include "config.hpp"
#include "webserver.hpp"

Main(Argv& args) {
    log(DEBUG, "Starting webserver...");
    Config config;
    config.parse(args);
    Webserver server(config);
    server.start();
    return ErrorCode::success;
}
