#include <libarcherus/log.hpp>

#include "argument.hpp"

Argument::Argument(std::string value) : value(value) {
    utils::log(Level(Debug), "Constructed argument");
}

const std::string Argument::get() const {
    return value;
}
