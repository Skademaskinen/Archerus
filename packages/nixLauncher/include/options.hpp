#pragma once

#include "launcher_option.hpp"
class Options {
public:
    typedef std::function<void()> Callback;
    Options(Callback);
    LauncherOption hidden;
    LauncherOption unfree;
    const Callback callback;
};
