#pragma once

#include "type.hpp"

class HomeManager : public Type {
    using Type::config;
public:
    HomeManager(Config&);
    void extra_init() override;
};
