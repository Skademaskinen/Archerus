#include <argparse/argparse.hpp>

#include "config.hpp"
#include "webserver.hpp"
#include "log.hpp"

int main(int argc, char* argv[]) {
    LOG("Starting webserver...");
    Config config;
    config.parse(argc, argv);
    Webserver server(config);
    server.start();
}
