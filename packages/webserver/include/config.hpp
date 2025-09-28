#pragma once

#include <map>
#include <string>

#include <argparse/argparse.hpp>
#include <libarcherus/base_config.hpp>


class File {
    std::string type;
    std::filesystem::path path;
public:
    File(const std::string& type, const std::filesystem::path& path);
    File();
    const std::string& get_type() const;
    const std::filesystem::path& get_path() const;
};

class Config : public archerus::BaseConfig {
    using BaseConfig::parser;
    unsigned int port;
    std::map<std::string, std::string> routes;
    std::map<std::string, File> extra_route_files;

    void parseJson() override;
public:
    Config();

    const unsigned int get_port() const;
    const std::map<std::string, std::string>& get_routes() const;
    const std::map<std::string, File>& get_extra_route_files() const;
};
