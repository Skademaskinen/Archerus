#include <libarcherus/log.hpp>

#include "argument.hpp"

Argument::Argument(const std::string& value) : value(value) {
    log(DEBUG, "Constructed argument");
}

const std::string Argument::get() const {
    return value;
}
