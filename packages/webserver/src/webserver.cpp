#include <fstream>
#include <sstream>

#include <libarcherus/log.hpp>

#include "webserver.hpp"

Webserver::Webserver(Config& config) : config(config) {
    log(DEBUG, "Webserver initialized");
    if(!config.isParsed()) {
        log(DEBUG, "Config not yet parsed, exiting");
        exit(1);
    }
    for(const auto& [route, file] : config.get_routes()) {
        handlers[route] = [&route, &file](httplib::Request req, httplib::Response& res) {
            log(DEBUG, "Serving route: %s -> %s", route.c_str(), file.c_str());
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
            log(DEBUG, "Serving extra route: %s -> %s", route.c_str(), file.get_path().c_str());
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
        log(DEBUG, "Registered route: %s", route.c_str());
    }
}

Webserver::~Webserver() {
    log(DEBUG, "Webserver destroyed");
}

void Webserver::start() {
    int port = config.get_port();
    log(DEBUG, "Starting server on port %d", port);
    server.listen("", port);
}
