#include "argument.hpp"
#include "log.hpp"

Argument::Argument(std::string value) : value(value) {
    LOG("Constructed argument");
}

const std::string Argument::get() const {
    return value;
}
