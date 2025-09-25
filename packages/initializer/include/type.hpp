#pragma once

#include <string>
#include <fstream>

#include "config.hpp"

// this function should replace all instances of fst with snd in content
inline std::string substitute_all(std::string fst, std::string snd, std::string content) {
    size_t pos = 0;
    while ((pos = content.find(fst, pos)) != std::string::npos) {
        content.replace(pos, fst.length(), snd);
        pos += snd.length();
    }
    return content;
}

// abstract type with no implementations, if the virtual methods are called, the linker should exit
class Type {
protected:
    Config& config;
    std::filesystem::path path;
    std::filesystem::path flake_path;
    std::map<std::string, std::string> substitution_pairs;
    Type(Config& config, std::filesystem::path path, std::filesystem::path flake_path) : config(config), path(path), flake_path(flake_path) {
        if (std::filesystem::exists(path)) {
            log(DEBUG, "Error, {} exists...", path.string());
            exit(1);
        }
    }
public:
    void initialize_i() {
        std::ifstream input;
        std::ofstream output;
        std::stringstream ss;
        input.open(flake_path);
        ss << input.rdbuf();
        std::string file = ss.str();
        for(const auto& [fst, snd] : substitution_pairs) {
            file = substitute_all(fst, snd, file);
        }
        output.open(path);
        output << file;
        output.close();
        extra_init();
    };
    void switch_i() {
        log(DEBUG, "Mock Type");
    };
    virtual void extra_init() = 0;
};
