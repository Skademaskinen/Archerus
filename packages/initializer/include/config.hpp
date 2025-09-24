#pragma once

#include <libarcherus/base_config.hpp>

enum Mode {
    NixosMode,
    HomeManagerMode
};

namespace instructions {
    enum Instruction {
        Initialize,
        Switch
    };
    inline Instruction to_instruction(std::string i) {
        return (std::map<std::string, Instruction>){
            {"initialize", Initialize},
            {"switch", Switch}
        }[i];
    }
    inline std::string from_instruction(Instruction i) {
        return (std::map<Instruction, std::string>){
            {Initialize, "initialize"},
            {Switch, "switch"}
        }[i];
    }
};

class Config : public archerus::BaseConfig {
    using BaseConfig::parser;
    Mode mode;
    std::vector<instructions::Instruction> instructions;
public:
    Config();

    const Mode& get_mode() const;
    const std::vector<instructions::Instruction>& get_instructions() const;
    const std::filesystem::path get_desktop_prefix() const;
    const std::string get_hostname() const;
    const std::string get_username() const;
    const std::filesystem::path get_home_flake_template_path() const;
    const std::filesystem::path get_nixos_flake_template_path() const;
};
