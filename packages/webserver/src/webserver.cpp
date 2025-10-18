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
            std::ifstream f(file.get_path(), std::ios::binary);
            if (!f) {
                res.status = 404;
                res.set_content("File not found", "text/plain");
                return;
            }
            f.seekg(0, std::ios::end);
            size_t file_size = f.tellg();
            f.seekg(0, std::ios::beg);
            f.close();

            res.set_content_provider(
                file_size,
                file.get_type(),
                [&file](const size_t& offset, const size_t& length, const httplib::DataSink &sink) {
                    std::ifstream f(file.get_path(), std::ios::binary);
                    constexpr size_t buffer_size = 8192;
                    char buffer[buffer_size];
                    f.seekg(offset);
                    auto to_read = std::min(buffer_size, length);
                    f.read(buffer, to_read);
                    std::streamsize read_bytes = f.gcount();
                    if (read_bytes > 0) {
                        sink.write(buffer, static_cast<size_t>(read_bytes));
                        return true;
                    }
                    return false;
                }
            );
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
