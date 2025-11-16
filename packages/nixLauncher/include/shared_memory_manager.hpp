#pragma once
#include <QSharedMemory>

class SharedQuitFlag {
public:
    SharedQuitFlag();

    void signalQuit();

    bool shouldQuit();

private:
    QSharedMemory mem;
};

