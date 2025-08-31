#include "webserver.hpp"
#include "log.hpp"
#include <fstream>
#include <sstream>

Webserver::Webserver(Config& config) : config(config) {
    LOG("Webserver initialized");
    if(!config.is_parsed()) {
        LOG("Config not yet parsed, exiting");
        exit(1);
    }
    for(const auto& [route, file] : config.get_routes()) {
        handlers[route] = [&route, &file](httplib::Request req, httplib::Response& res) {
            LOG("Serving route: %s -> %s", route.c_str(), file.c_str());
            std::ifstream f;
            std::stringstream ss;
            std::string content;
            f.open(file);
            ss << f.rdbuf();
            f.close();
            content = ss.str();
            res.set_content(content, "text/html");
            return;
        };
    }
    for(const auto& [route, file] : config.get_extra_route_files()) {
        handlers[route] = [&route, &file](httplib::Request req, httplib::Response& res) {
            LOG("Serving extra route: %s -> %s", route.c_str(), file.get_path().c_str());
            std::ifstream f;
            std::stringstream ss;
            std::string content;
            f.open(file.get_path());
            ss << f.rdbuf();
            f.close();
            content = ss.str();
            res.set_content(content, file.get_type());
            return;
        };
    }
    for(const auto& [route, handler] : handlers) {
        server.Get(route.c_str(), handler);
        LOG("Registered route: %s", route.c_str());
    }
}

Webserver::~Webserver() {
    LOG("Webserver destroyed");
}

void Webserver::start() {
    int port = config.get_port();
    LOG("Starting server on port %d", port);
    server.listen("", port);
}
