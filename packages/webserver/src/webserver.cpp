#include <fstream>
#include <sstream>

#include <libarcherus/log.hpp>

#include "webserver.hpp"

Webserver::Webserver(Config& config) : config(config) {
    utils::log(Level(utils::Debug), "Webserver initialized");
    if(!config.is_parsed()) {
        utils::log(Level(utils::Debug), "Config not yet parsed, exiting");
        exit(1);
    }
    for(const auto& [route, file] : config.get_routes()) {
        handlers[route] = [&route, &file](httplib::Request req, httplib::Response& res) {
            utils::log(Level(utils::Debug), "Serving route: %s -> %s", route.c_str(), file.c_str());
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
            utils::log(Level(utils::Debug), "Serving extra route: %s -> %s", route.c_str(), file.get_path().c_str());
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
        utils::log(Level(utils::Debug), "Registered route: %s", route.c_str());
    }
}

Webserver::~Webserver() {
    utils::log(Level(utils::Debug), "Webserver destroyed");
}

void Webserver::start() {
    int port = config.get_port();
    utils::log(Level(utils::Debug), "Starting server on port %d", port);
    server.listen("", port);
}
