#pragma once

#include "utils.hpp"
#include <argparse/argparse.hpp>

// base virtual config class

namespace archerus {
    class BaseConfig {
    protected:
        argparse::ArgumentParser parser;
        bool parsed;
        BaseConfig(std::string name) : parser(name), parsed(false) {
        }
    
    public:
        virtual void parseJson();
        void parse(const int argc, const char* argv[]);
        void parse(const Argv& args);
        ~BaseConfig();
        bool isParsed() const;
    };

}
