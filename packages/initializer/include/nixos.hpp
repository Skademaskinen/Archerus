#pragma once

#include "type.hpp"

class Nixos : public Type {
public:
    Nixos(Config&);
    void extra_init() override;
};
