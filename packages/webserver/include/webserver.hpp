#pragma once

#include <functional>
#include <httplib.h>
#include <map>
#include <thread>

#include "config.hpp"

typedef std::function<void(httplib::Request, httplib::Response&)> handler_t;

class Webserver {
    Config& config;
    httplib::Server server;
    std::map<std::string, handler_t> handlers;
    std::vector<std::thread> handlerThreads;
public:
    Webserver(Config&);
    ~Webserver();

    void start();
};
