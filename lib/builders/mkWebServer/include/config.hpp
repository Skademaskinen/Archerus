#pragma once

#include <argparse/argparse.hpp>
#include <map>
#include <string>

class File {
    std::string type;
    std::string path;
public:
    File(const std::string& type, const std::string& path);
    File();
    const std::string& get_type() const;
    const std::string& get_path() const;
};

class Config {
    argparse::ArgumentParser parser;
    unsigned int port;
    bool parsed;
    std::map<std::string, std::string> routes;
    std::map<std::string, File> extra_route_files;

    void process_json_config();
public:
    Config();
    ~Config();
    void parse(int argc, char* argv[]);
    bool is_parsed() const;

    const unsigned int get_port() const;
    const std::map<std::string, std::string>& get_routes() const;
    const std::map<std::string, File>& get_extra_route_files() const;
};
