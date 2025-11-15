#pragma once

#include "shared_memory_manager.hpp"

SharedQuitFlag::SharedQuitFlag() {
    mem.setKey("my_app_global_quit_flag");
    mem.attach(); // Try attaching first
    if (!mem.isAttached()) {
        mem.create(sizeof(int));
        mem.lock();
        *(int*)mem.data() = 0;
        mem.unlock();
    }
}

void SharedQuitFlag::signalQuit() {
    mem.lock();
    *(int*)mem.data() = 1;
    mem.unlock();
}

bool SharedQuitFlag::shouldQuit() {
    mem.lock();
    int val = *(int*)mem.data();
    mem.unlock();
    return val == 1;
}
