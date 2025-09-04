#include "argument.hpp"
#include "log.hpp"

Argument::Argument(std::string value) : value(value) {
    utils::log(Level(utils::Debug), "Constructed argument");
}

const std::string Argument::get() const {
    return value;
}
