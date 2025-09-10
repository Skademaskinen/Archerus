#include <argparse/argparse.hpp>
#include <libarcherus/log.hpp>

#include "config.hpp"
#include "webserver.hpp"

int main(int argc, char* argv[]) {
    utils::log(Level(utils::Debug), "Starting webserver...");
    Config config;
    config.parse(argc, argv);
    Webserver server(config);
    server.start();
}
