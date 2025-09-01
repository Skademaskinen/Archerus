#include "log.hpp"
#include <argparse/argparse.hpp>

// base virtual config class
class BaseConfig {
protected:
    argparse::ArgumentParser parser;
    bool parsed;
    BaseConfig(std::string name) : parser(name), parsed(false) {
    }

public:
    virtual void parse_json() {
        LOG("Running default (empty) parse_json implementation");
    };
    void parse(int argc, char* argv[]) {
        try {
            parser.parse_args(argc, argv);
        } catch (const std::runtime_error& err) {
            LOG("Argument parsing error: %s", err.what());
            exit(1);
        }
        parse_json();
        parsed = true;
    }
    ~BaseConfig() {
        LOG("Destroying Base config child");
    }
    bool is_parsed() const {
        return parsed;
    }
};
